function BaseGroup:CheckTarget(target, idx, book, caster)
	if UnitIsDead(target) then
		return nil
	end
	
	if SpellHasRange(idx, book) and  IsSpellInRange(idx, book, target) == 0 then
		return nil
	end

	local inRange, checkedRange = UnitInRange(target)
	if checkedRange and not inRange then 
		return nil
	end
	
	local lastBanned = IndicatorFrame.LoS.Banned[GetUnitName(target,true)] or 0
	
	if UnitIsPlayer(target) and GetTime() < lastBanned + 5 then
		return nil
	end
	
		
	if UnitCanAttack(caster, target) and IsHarmfulSpell(idx, book) == true then
		return 1
	end

		  
	if UnitCanAssist(caster, target) and IsHelpfulSpell(idx, book) == true then
		return 1
	end

	-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
	if IsHarmfulSpell(idx, book) == false and IsHelpfulSpell(idx, book) == false then
		return 1
	end
	
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
			return result
		end
	end
end

TBSkipIsUsableSpellCkeck = 
{
	"Слово силы: Щит",
	"Быстрое восстановление",
}


function BaseGroup:CanUse(key, ignoreChannel)

	local result = self:CreateDerived()
    local caster = "player"
	local spell = TBGetSpell(key)

	-- если не нашли в спеллбуке - значит спелл заменен, и не должен быть сколдован
	if spell == nil then
		return result
	end
	
    if UnitIsDead(caster) then
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
        return result
    end	
	
	-- КД спелла
	local startTime, duration = GetSpellCooldown(spell.idx, spell.book)
	local endTime = startTime + duration
	if GetTime() < endTime - delay then
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
			return result
		end
	end
           
    local et = select(6,UnitCastingInfo(caster))
    if et and GetTime() < (et / 1000.0) - delay  then 
        return result
    end
	
	if ignoreChannel == nil then
		local et = select(6, UnitChannelInfo(caster))
		if et and GetTime() < (et / 1000) - delay then 
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