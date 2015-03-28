BaseGroup = {}
function BaseGroup:CreateDerived()
	local result = {}
	setmetatable(result, {__index = BaseGroup})
	return result
end




TBNeedFullHealList = {
		["Чавканье"] = "Чавканье"
	}


function BaseGroup:NeedFullHeal()
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local needHeal = nil
		for spell,_ in pairs(TBNeedFullHealList) do
			needHeal = needHeal or UnitAura(key, spell, nil, "HARMFUL")
		end
		if needHeal then
			result[key] = value
		end
	end
	
	return result
end

function BaseGroup:Best()

	for key,value in pairs(self) do
		if UnitIsUnit(key, "focus") then
			return value
		end
	end

	for key,value in pairs(self) do
		if UnitIsUnit(key, "target") then
			return value
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
		--local hp = 100 * (UnitHealth(key) + (UnitGetIncomingHeals(key) or 0)) / UnitHealthMax(key)
		local hp = 100 * UnitHealth(key) / UnitHealthMax(key)
		if hp < minHP then
			minHP = hp
			unit = value
		end
	end
	return unit
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
	local target = BaseGroup:CreateDerived()
	local tanks = BaseGroup:CreateDerived()
	local healers = BaseGroup:CreateDerived()
  
	-----
	player["player"] = Targetting("player")
	-----
	focus["focus"]  = Targetting("focus")
	focus["focustarget"] = Assisting("focustarget", focus["focus"])
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
	
	local DamagePerHealer = 0;
	local HealersCount = 0;
	for k,v in pairs(party) do
		if UnitIsDead(k) == false then
			DamagePerHealer = DamagePerHealer + ( UnitHealthMax(k) - UnitHealth(k) ) / UnitHealthMax(k)
		end
		
		if UnitGroupRolesAssigned(k) == "TANK" then
			tanks[k] = Targetting(k)
		end
		if UnitGroupRolesAssigned(k) == "HEALER" then
			healers[k] = Targetting(k)
			if UnitIsDead(k) == false then
				HealersCount = HealersCount + 1
			end
		end		
	end
	if HealersCount == 0 then
		HealersCount = 1
	end

	party["mouseover"] = Targetting("mouseover")
	
	-----
	target["target"] = Targetting("target")
	-----
	local result = {}
	result.player = player
	result.party = party
	result.focus = focus
	result.targets = targets
	result.target = target
	result.tanks = tanks
	result.healers = healers
	result.DamagePerHealer = DamagePerHealer / HealersCount
	return result
end

--[[
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
--]]