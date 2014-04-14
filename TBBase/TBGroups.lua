BaseGroup = {}
function BaseGroup:CreateDerived()
	local result = {}
	setmetatable(result, {__index = BaseGroup})
	return result
end

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



function BaseGroup:Aura(spellKey, isMine, isSelf, inverseResult, timeLeft, stacks)
    local result = self:CreateDerived()
	
	local spell = IndicatorFrame.ByKey[spellKey]
	
	if spell == nil then
		return result
	end
	
	mask = "HELPFUL"
	if isMine then
        mask = mask.."|PLAYER"
    end


	function HasInnerAura(Key, Spell, TimeLeft, Stacks)
		local stacksBase,_,_,etBase = select(4, UnitAura(Key, Spell.BaseName, nil, mask))
		local stacksReal,_,_,etReal = select(4, UnitAura(Key, Spell.RealName, nil, mask))
		local et = etBase or etReal
		local stacks = stacksBase or stacksReal or 0
		
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

function BaseGroup:MinHP(focusFirst)
	if focusFirst then
		for key,value in pairs(self) do
			if UnitIsUnit(key, "focus") then
				return value
			end
		end
	end
	local minHP = 101
	local unit = nil
	for key,value in pairs(self) do
		local hp = 100 * UnitHealth(key) / UnitHealthMax(key)
		if hp < minHP then
			minHP = hp
			unit = value
		end
	end
	return unit
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

function TBGroups()
	function Targetting(target)
		local result = {
				action = "target",
				value = target
			}
		return result
	end
  
	function Assisting(target, cond)
		local result = {
				action = "assist",
				value = target,
				condition = cond
			}
		return result
	end
  
 
	local player = BaseGroup:CreateDerived()
	local focus = BaseGroup:CreateDerived()
	local party = BaseGroup:CreateDerived()
	local targets = BaseGroup:CreateDerived()
  
	-----
	player["player"] = Targetting("player")
	-----
	focus["focus"]  = Targetting("focus")
	-----
	if IsInRaid() then
		for i = 1,GetNumGroupMembers() do
			party["raid"..i] = Targetting("raid"..i)
		end
	else
		party["player"] = Targetting("player")
		if IsInGroup() then
			for i = 1,GetNumGroupMembers() - 1 do 
				party["party"..i] = Targetting("party"..i)
			end
		end
	end
	-----
	targets["focus"] = Targetting("focus")
	for k,v in pairs(party) do
		targets[k.."target"] = Assisting(k.."target", v)
		targets[k] = Targetting(k)
	end  
	-----  
	return player, party, focus, targets
end


function CastKey(key, target)
  result = {
    action = "spell",
    value = key,
    condition = target
  }
  return result
end


function SuccessCondiotion(command)  

	if command == nil then
		return 1
	end

	-- если мы хотим кастить в себя, и при этом в фокусе цель, которую нельзя лечить - не надо менять цель
	if command.action == "target" and UnitIsUnit("player", command.value) and UnitCanAttack("player", "target") then -- По моему тут ошибка
		return 1
	end

	if command.action == "target" and UnitIsUnit("target", command.value) then
		return 1
	end

	if command.action == "assist" and UnitIsUnit("target", command.value) then
		return 1
	end  
end

function Execute(command)
	if SuccessCondiotion(command.condition) then
		return command.value
	else
		return Execute(command.condition)
	end
end
