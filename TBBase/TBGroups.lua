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

function BaseGroup:MinHP()
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



TBBestTankKey = nil

function TankIncomingDamage(key)
	if key == nil then
		return nil
	end
	
	for i=1,40,1 do
		local id = select(11, UnitAura(key,i))
		
		if id == 158300 then 
			return select(17,UnitAura(key,i))
		end
	end
	
	return nil
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
	local mainTank = BaseGroup:CreateDerived()
  
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
	targets["mouseover"] = Targetting("mouseover")
	for k,v in pairs(party) do
		targets[k.."target"] = Assisting(k.."target", v)
		targets[k] = Targetting(k)
	end 
	
	--local DamagePerHealer = 0;
	--local HealersCount = 0;
	local incDmg = TankIncomingDamage(TBBestTankKey) or 0
	if incDmg == 0 then
		TBBestTankKey = nil
	end
	
	for k,v in pairs(party) do
		--if UnitIsDead(k) == false then
		--	DamagePerHealer = DamagePerHealer + ( UnitHealthMax(k) - UnitHealth(k) ) / UnitHealthMax(k)
		--end
		
		local dmg = TankIncomingDamage(k)
		if dmg and UnitAura(k,"Стойка гладиатора")==nil then
			tanks[k] = Targetting(k)
		
			if dmg > incDmg * 1.2 then
				TBBestTankKey = k
			end
		end

		--if UnitGroupRolesAssigned(k) == "HEALER" then
		--	if UnitIsDead(k) == false then
		--		HealersCount = HealersCount + 1
		--	end
		--end
	end
	
	if UnitName("focus") then
		-- Если есть цель в фокусе - значит она назначена главной целью
		TBBestTankKey = "focus"
		
		local needAddFocus = true
		for k,v in pairs(tanks) do
			if UnitIsUnit(k,"focus") or UnitIsUnit(k,"focustarget") then
				needAddFocus = nil
			end
		end
		
		if needAddFocus then
			tanks["focus"]  = Targetting("focus")
			tanks["focustarget"] = Assisting("focustarget", tanks["focus"])
		end
	end
	
	if TBBestTankKey then	
		mainTank[TBBestTankKey] = Targetting(TBBestTankKey)
		mainTank[TBBestTankKey.."target"] = Assisting(TBBestTankKey.."target", mainTank[TBBestTankKey])
	end
	
	--if HealersCount == 0 then
	--	HealersCount = 1
	--end

	--party["mouseover"] = Targetting("mouseover")
	
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
	--result.healers = healers
	result.mainTank = mainTank
	--result.DamagePerHealer = DamagePerHealer / HealersCount
	return result
end