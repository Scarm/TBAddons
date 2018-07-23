function BaseGroup:CheckTarget(target, spellID, caster, ignoreHarm)
	if UnitIsDead(target) then
		return nil
	end

	TBLogValues["SpellHasRange"] = SpellHasRange(spellID) or "nil"
	TBLogValues["IsSpellInRange"] = IsSpellInRange(GetSpellInfo(spellID), target) or "nil"

	if IsSpellInRange(GetSpellInfo(spellID), target) == 0 then
		TBLogValues["can use fail"] = "IsSpellInRange"
		return nil
	end

	local inRange, checkedRange = UnitInRange(target)
	if checkedRange and not inRange then
		TBLogValues["can use fail"] = "UnitInRange"
		return nil
	end

	local lastBanned = IndicatorFrame.LoS.Banned[GetUnitName(target,true)] or 0

	if UnitIsPlayer(target) and GetTime() < lastBanned + 5 then
		TBLogValues["can use fail"] = "LoS"
		return nil
	end

	TBLogValues["IsHarmfulSpell"] = IsHarmfulSpell(GetSpellInfo(spellID)) or "nil"
	TBLogValues["IsHelpfulSpell"] = IsHelpfulSpell(GetSpellInfo(spellID)) or "nil"
	TBLogValues["UnitCanAssist"] = UnitCanAssist(caster, target) or "nil"
	TBLogValues["UnitCanAttack"] = UnitCanAttack(caster, target) or "nil"

	if ignoreHarm == nil then

		if UnitCanAttack(caster, target) then
			TBLogValues["TargetType"] = "UnitCanAttack"
			if IsHarmfulSpell(GetSpellInfo(spellID)) then
				TBLogValues["can use success"] = "IsHarmfulSpell"
				return 1
			end
		end


		if UnitCanAssist(caster, target) then
			TBLogValues["TargetType"] = "UnitCanAssist"
			if IsHelpfulSpell(GetSpellInfo(spellID)) then
				TBLogValues["can use success"] = "IsHelpfulSpell"
				return 1
			end
		end

		-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
		if not IsHarmfulSpell(GetSpellInfo(spellID)) and not IsHelpfulSpell(GetSpellInfo(spellID)) then
			TBLogValues["TargetType"] = "Any"
			TBLogValues["can use success"] = "IsHelpfulSpell&IsHarmfulSpell"
			return 1
		end
	else
		return 1
	end

	TBLogValues["can use fail"] = "default"
	return nil
end

function TBGetSpell(key)
	local spellID = IndicatorFrame.Spec.Spells[key]

	if spellID == nil then
		return nil
	end

	local base = FindBaseSpellByID(spellID)
	local result = {}
	result.spellID = spellID
	result.baseSpell = base
	return result
end

TBSkipIsUsableSpellCkeck =
{
	"Слово силы: Щит",
	"Извержение Бездны"
}


function BaseGroup:CanUse(key, ignoredChannels, ignoreHarm)

	local result = self:CreateDerived()
    local caster = "player"
	local spell = TBGetSpell(key)

	-- если не нашли в спеллбуке - значит спелл заменен, и не должен быть сколдован
	TBLogValues["spell is null"] = nil
	if spell == nil then
		TBLogValues["spell is null"] = 1
		return result
	end

	TBLogValues["spell name"] = key .. "(" .. spell.spellID .. "/" .. spell.baseSpell .. ")"
	TBLogValues["can use fail"] = nil
	TBLogValues["can use success"] = nil
	TBLogValues["TargetType"] = nil
	TBLogValues["IsUsableSpell"] = nil
    if UnitIsDead(caster) then
		TBLogValues["can use fail"] = "UnitIsDead(caster)"
        return result
    end

	if IsSpellKnown(spell.baseSpell)==false then
		TBLogValues["can use fail"] = "IsSpellKnown(key)"
		return result
	end

	if FindSpellOverrideByID(spell.spellID) ~= spell.spellID then
		TBLogValues["can use fail"] = "FindSpellOverrideByID (spellID)"..FindSpellOverrideByID(spell.spellID).." "..spell.spellID
		return result
	end

	if FindSpellOverrideByID(spell.baseSpell) ~= spell.spellID then
		TBLogValues["can use fail"] = "FindSpellOverrideByID (baseSpell)"..FindSpellOverrideByID(spell.spellID).." "..spell.spellID
		return result
	end

	local delay = 0

	-- Как я понимаю - затык по спеллу
	local startTimeLoC, durationLoC = GetSpellLossOfControlCooldown(spell.spellID)
	local endTimeLoC = startTimeLoC + durationLoC
	if GetTime() < endTimeLoC - delay then
		TBLogValues["can use fail"] = "Loss of Control"
        return result
    end

	-- КД спелла
	local startTime, duration = GetSpellCooldown(spell.spellID)
	local endTime = startTime + duration
	if GetTime() < endTime - delay then
		TBLogValues["can use fail"] = "GetSpellCooldown"
        return result
    end

	local skip = false
	for k,v in pairs(TBSkipIsUsableSpellCkeck) do
		if key == v then
			skip = true
		end
	end

	if skip == false then
		if IsUsableSpell(spell.spellID) == false then
			TBLogValues["can use fail"] = "IsUsableSpell"
			return result
		else
			TBLogValues["IsUsableSpell"] = "true"
		end
	end

  local et = select(5,UnitCastingInfo(caster))
  if et and GetTime() < (et / 1000.0) - delay  then
	TBLogValues["can use fail"] = "Casting"
      return result
  end


	local et = select(5, UnitChannelInfo(caster))
	local channelName = UnitChannelInfo(caster)
	if et and GetTime() < (et / 1000) - delay then
		local needIgnore = false
		for k,v in pairs(ignoredChannels or {}) do
				local sp = TBGetSpell(v)
				if sp == nil then
					print(v)
				end
				if sp.name == channelName then
					needIgnore = true
				end
		end

		if needIgnore == false then
			TBLogValues["can use fail"] = "Channeling"
			return result
		end
	end

	for key,value in pairs(self) do
		if self:CheckTarget(key, spell.baseSpell, caster, ignoreHarm) then
		--if self:CheckTarget(key, spell.spellID, caster, ignoreHarm) then
			result[key] = value
		end
	end

	return result
end
