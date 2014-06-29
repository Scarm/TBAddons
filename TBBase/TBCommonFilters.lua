function BaseGroup:RangeHP(minHP, maxHP)
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		local hp = 100 * UnitHealth(key) / UnitHealthMax(key)
		if (minHP == nil or hp > minHP) and (maxHP ==nil or hp < maxHP) then
			result[key] = value
		end
	end
	
	return result
end


-- метод отбирает просевшие цели в зависимости от количества маны у кастера
-- этот метод - упрощение использования RangeHP для вариации маны
function BaseGroup:HealingRange(minHP, maxHP)
	local result = self:CreateDerived()
	local mpp = UnitPower("player") / UnitPowerMax("player")
	local limit = minHP + (maxHP - minHP) * mpp
	
	for key,value in pairs(self) do
		local hp = 100 * UnitHealth(key) / UnitHealthMax(key)
		if hp < limit then
			result[key] = value
		end
	end
	
	return result	
end

function BaseGroup:UnBlocked()
	return self
end

function BaseGroup:AutoAttacking(yes)
	if (IndicatorFrame.InCombat and yes) or ( not IndicatorFrame.InCombat and not yes) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Moving(yes)
	local speed = GetUnitSpeed("player")
	if speed > 0 then
		IndicatorFrame.LastMoving = GetTime()
	end
	if IndicatorFrame.LastMoving == nil then
		IndicatorFrame.LastMoving = GetTime()
	end
	
	local cond = GetTime() > IndicatorFrame.LastMoving + 0.5
	if (cond and yes) or (not cond and not yes) then
		return self
	end
	
	return self:CreateDerived()
end

function BaseGroup:CanInterrupt()
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local c1,i1 = select(8,UnitCastingInfo(key))
		local c2,i2 = select(8,UnitChannelInfo(key))
		if (c1 and not i1) or (c2 and not i2) then
			result[key] = value
		end
	end
	
	return result	
end

function BaseGroup:NeedDecurse(...)
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local needDecurse = nil
		
		local types = select("#", ...)
		dispelType = select(5, UnitAura(key, 1, "HARMFUL"))
		for i = 1,types,1 do
			if dispelType == select(i, ...) then
				needDecurse = 1
			end			
		end

		if needDecurse then
			result[key] = value
		end
	end
	
	return result
end

function BaseGroup:Aura(spellKey, isMine, isSelf, inverseResult, timeLeft, stacks)
    local result = self:CreateDerived()
	
	local spell = IndicatorFrame.ByKey[spellKey]
	
	if spell == nil then
		return result
	end
	
	function HasInnerAura(Key, Spell, TimeLeft, Stacks)
	
		local mask = "HARMFUL"
		if isMine then
			mask = mask.."|PLAYER"
		end
	
		local stacksBase,_,_,etBase = select(4, UnitAura(Key, Spell.BaseName, nil, mask))
		local stacksReal,_,_,etReal = select(4, UnitAura(Key, Spell.RealName, nil, mask))
		local et = etBase or etReal
		local stacks = stacksBase or stacksReal
		
		local mask = "HELPFUL"
		if isMine then
			mask = mask.."|PLAYER"
		end
	
		local stacksBase,_,_,etBase = select(4, UnitAura(Key, Spell.BaseName, nil, mask))
		local stacksReal,_,_,etReal = select(4, UnitAura(Key, Spell.RealName, nil, mask))
		et = et or etBase or etReal
		stacks = stacks or stacksBase or stacksReal or 0		
		
		
		
		if et and ((et == 0) or (et - GetTime() > TimeLeft)) then
			if Stacks then
				if  stacks >= Stacks then
					return 1
				else
					return nil
				end
			else
				return 1
			end
		end
	end
	
	if isSelf then
		if HasInnerAura("player", spell, timeLeft or 0, stacks) then
			if inverseResult == nil then
				for key,value in pairs(self) do
					result[key] = value
				end
			end
		else
			if inverseResult then
				for key,value in pairs(self) do
					result[key] = value
				end
			end
		end
	else
		for key,value in pairs(self) do
			if HasInnerAura(key, spell, timeLeft or 0, stacks) then
				if inverseResult == nil then
					result[key] = value
				end
			else
				if inverseResult then
					result[key] = value
				end
			end
		end	
	end
	
	
	return result
end



function BaseGroup:CheckTarget(target, idx, book, caster)
	if UnitIsDead(target) then
		return nil
	end
	
	if SpellHasRange(idx, book) and  IsSpellInRange(idx, book, target) == 0 then
		return nil
	end 
		
	if UnitCanAttack(caster, target) and IsHarmfulSpell(idx, book) then
		return 1
	end

		  
	if UnitCanAssist(caster, target) and IsHelpfulSpell(idx, book) then
		return 1
	end

	-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
	if IsHarmfulSpell(idx, book)==nil and IsHelpfulSpell(idx, book)==nil then
		return 1
	end
	
	return nil

end


function BaseGroup:CanUse(key)
	local result = self:CreateDerived()
	
	local spell = IndicatorFrame.ByKey[key]
	if spell == nil then
		print("НЕ НАЙДЕН СПЕЛЛ! ", key)
		return result
	end
	
    local caster = "player"
    local idx = spell.TabIndex
	local book = spell.Type

    if UnitIsDead(caster) then
        return result
    end
	  
    if GetSpellCooldown(idx, book) ~= 0 then
        return result
    end
    
    if IsUsableSpell(idx, book) == nil then
        return result
    end
           
    local et = select(6,UnitCastingInfo(caster)) or select(6, UnitChannelInfo(caster))
    if et and et > GetTime() * 1000 then 
        return result
    end
	
	for key,value in pairs(self) do
		if self:CheckTarget(key, idx, book, caster) then
			result[key] = value
		end	
	end
	
	return result	
end