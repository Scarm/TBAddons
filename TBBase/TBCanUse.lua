function BaseGroup:CheckTarget(target, idx, book, caster)
	if UnitIsDead(target) then
		return nil
	end

	TBLogValues["SpellHasRange"] = SpellHasRange(idx, book) or "nil"
	TBLogValues["IsSpellInRange"] = IsSpellInRange(idx, book, target) or "nil"

	if IsSpellInRange(idx, book, target) == 0 then
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

	TBLogValues["IsHarmfulSpell"] = IsHarmfulSpell(idx, book) or "nil"
	TBLogValues["IsHelpfulSpell"] = IsHelpfulSpell(idx, book) or "nil"
	TBLogValues["UnitCanAssist"] = UnitCanAssist(caster, target) or "nil"
	TBLogValues["UnitCanAttack"] = UnitCanAttack(caster, target) or "nil"

	if UnitCanAttack(caster, target) and IsHarmfulSpell(idx, book) == true then
		TBLogValues["can use success"] = "IsHarmfulSpell"
		return 1
	end


	if UnitCanAssist(caster, target) and IsHelpfulSpell(idx, book) == true then
		TBLogValues["can use success"] = "IsHelpfulSpell"
		return 1
	end

	-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
	if IsHarmfulSpell(idx, book) == false and IsHelpfulSpell(idx, book) == false then
		TBLogValues["can use success"] = "IsHelpfulSpell&IsHarmfulSpell"
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
	local _,_,offset = GetSpellTabInfo(3)

    for index = 1, offset, 1 do
		local id = select(7,GetSpellInfo(index, "spell"))
		if id == spellID then
			local result = {}
			result.spellID = spellID
			result.idx = index
			result.book = "spell"
			result.name = GetSpellInfo(index, "spell")
			return result
		end
	end
end

TBSkipIsUsableSpellCkeck =
{
	"Слово силы: Щит",
	"Извержение Бездны"
}


function BaseGroup:CanUse(key, ignoredChannels)

	local result = self:CreateDerived()
    local caster = "player"
	local spell = TBGetSpell(key)

	-- если не нашли в спеллбуке - значит спелл заменен, и не должен быть сколдован
	TBLogValues["spell is null"] = nil
	if spell == nil then
		TBLogValues["spell is null"] = 1
		return result
	end

	TBLogValues["spell name"] = key
	TBLogValues["can use fail"] = nil

    if UnitIsDead(caster) then
		TBLogValues["can use fail"] = "UnitIsDead(caster)"
        return result
    end

	local lag = 50
	local delay = (GetCVar("maxSpellStartRecoveryOffset") - lag)/ 1000.0
	if delay < 0 then
		delay = 0
	end

	-- Как я понимаю - затык по спеллу
	local startTimeLoC, durationLoC = GetSpellLossOfControlCooldown(spell.spellID)
	local endTimeLoC = startTimeLoC + durationLoC
	if GetTime() < endTimeLoC - delay then
		TBLogValues["can use fail"] = "Loss of Control"
        return result
    end

	-- КД спелла
	local startTime, duration = GetSpellCooldown(spell.idx, spell.book)
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
		if IsUsableSpell(spell.idx, spell.book) == false then
			TBLogValues["can use fail"] = "IsUsableSpell"
			return result
		end
	end

  local et = select(6,UnitCastingInfo(caster))
  if et and GetTime() < (et / 1000.0) - delay  then
	TBLogValues["can use fail"] = "Casting"
      return result
  end


	local et = select(6, UnitChannelInfo(caster))
	local channelName = UnitChannelInfo(caster)
	if et and GetTime() < (et / 1000) - delay then
		local needIgnore = false
		for k,v in pairs(ignoredChannels or {}) do
				local sp = TBGetSpell(v)
				if sp.name == channelName then
					needIgnore = true
				end
		end

		if needIgnore == false then
			TBLogValues["can use fail"] = "Canneling"
			return result
		end
	end

	for key,value in pairs(self) do
		if self:CheckTarget(key, spell.idx, spell.book, caster) then
			result[key] = value
		end
	end

	return result
end
