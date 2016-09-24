function BaseGroup:Condition(value)
	if value then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Toggle(mode)
	if BaseGroupHelper.modes then
		if BaseGroupHelper.modes.toggle[mode] then
			return self
		else
			return self:CreateDerived()
		end
	end
	
	return nil
end

function BaseGroup:Enabled(key, activationType)
	if BaseGroupHelper.modes  then
		local spellID = IndicatorFrame.Spec.Spells[key]
		if activationType then
			if BaseGroupHelper.modes[activationType] == nil then
				return nil
			end
			
			if BaseGroupHelper.modes[activationType][spellID] then
				return self
			else
				return self:CreateDerived()
			end
		else
			-- Любой вид активации			
			if BaseGroupHelper.modes.auto[spellID] or BaseGroupHelper.modes.manual[spellID] then
				return self
			else
				return self:CreateDerived()
			end
		end
	end
	
	return nil
end

function BaseGroup:Talent(key, value)
	local talentID = IndicatorFrame.Spec.Talents[key]
	local enabled = select(4,GetTalentInfoByID(talentID,1))
	
	if value == nil then
		value = true
	end
	
	if (enabled and value) or (not enabled and not value) then
		return self
	end
	
	return self:CreateDerived()
end

-- Проверяем, что до восстановления спелла осталось value сек
function BaseGroup:SpellCooldown(key, value, bound)
	local spellID = IndicatorFrame.Spec.Spells[key]
	local startTime, duration = GetSpellCooldown(spellID)
		
	local left = startTime + duration - GetTime()
	
	if bound == "lt" then
		if value <= left then
			return self
		end
		return self:CreateDerived()
	end
	
	if bound == "gt" then
		if value >= left then
			return self
		end
		return self:CreateDerived()
	end
end

function BaseGroup:InSpellRange(key, inverse)
	local spell = TBGetSpell(key)
	local result = self:CreateDerived()
	
	for k,v in pairs(self) do
		if (IsSpellInRange(spell.idx, spell.book, k) == 1) == (inverse == nil) then
			result[k] = v
		end
	end
	
	return result
end
--[[
function BaseGroup:ZeroThread()
	local result = self:CreateDerived()
	
	for k,v in pairs(self) do
		local threadValue = select(5,UnitDetailedThreatSituation("player", k)) or 0
		if threadValue == 0 then
			result[k] = v
		end
	end
	
	return result
end


function BaseGroup:HasBossDebuff()
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		for i=1,40,1 do
			local name = UnitAura(key,i,"HARMFUL")
			local id = select(11, UnitAura(key,i,"HARMFUL"))
			
			if id and name and TBDebuffList[id] == name then
				result[key] = value
			end
		end	
	end
	
	return result
end
--]]

function BaseGroup:AuraGroup(group)
local result = self:CreateDerived()
	for key,value in pairs(self) do
		for i=1,40,1 do
			local name = UnitAura(key,i,"HARMFUL")
			local id = select(11, UnitAura(key,i,"HARMFUL"))
			
			if id and name then
				if TBAttributes[id] and TBAttributes[id][group] then
					result[key] = value
				end
			end
		end	
	end
	
	return result	
end

function BaseGroup:Moving(value)
	local speed = GetUnitSpeed("player")
	if speed > 0 then
		IndicatorFrame.LastMoving = GetTime()
	end
	if IndicatorFrame.LastMoving == nil then
		IndicatorFrame.LastMoving = GetTime()
	end
	
	local isMoving = GetTime() < IndicatorFrame.LastMoving + 0.1
	
	if value == nil then
		return nil
	end
	
	if (isMoving and value) or (not isMoving and not value) then
		return self
	end
	
	return self:CreateDerived()
end

function BaseGroup:CanInterrupt(key)
	local function IsCast(key)
		local et = select(6,UnitCastingInfo(key))
		local ni = select(9,UnitCastingInfo(key))
		return et and (GetTime() + 0.5 > et / 1000) and not ni
	end
	
	local function IsChannel(key)
		local ni = select(8,UnitChannelInfo(key))
		local name = UnitChannelInfo(key)
		return name and not ni
	end

	local result = self:CreateDerived()
	for key,value in pairs(self) do
		if IsCast(key) or IsChannel(key) then
			result[key] = value
		end
	end
	
	return result	
end

function BaseGroup:NeedDecurse(...)
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local needDecurse = nil
		
		local debuffNum = 1
		local needContinue = 1
		-- проходим по всем дебаффам, пока они не кончатся, или не найдем хоть что то для диспела
		while needContinue do
			local types = select("#", ...)
			n,_,_,_,dispelType = UnitAura(key, debuffNum, "HARMFUL")
			if n then
				-- какой то дебафф есть, проверим, можно ли его диспеллить
				for i = 1,types,1 do
					if dispelType == select(i, ...) then
						needDecurse = 1
						needContinue = nil
					end			
				end
			else
				--дебаффы закончились
				needContinue = nil
			end
			debuffNum = debuffNum + 1
		end

		if needDecurse then
			result[key] = value
		end
	end
	
	return result
end



function BaseGroup:Charges(key, charges, dt)
	local spellID = IndicatorFrame.Spec.Spells[key]
	
	local ch, maxCh, start, duration = GetSpellCharges(spellID)
	dt = dt or 0
	
	if ch and ch < maxCh and ch > 0 then
		if GetTime() > start + duration - dt then
			ch = ch + 1
		end
	end
	
	if ch and charges and ch >= charges then
		return self
	end
	
	return self:CreateDerived()
end

function BaseGroup:CanAttack()
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		if UnitCanAttack("player", key) then
			result[key] = value
		end
	end
	
	return result	
end

function BaseGroup:CanAssist()
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		if UnitCanAssist("player", key) then
			result[key] = value
		end
	end
	
	return result	
end

function BaseGroup:AffectingCombat(val)
	if val == nil then
		return nil
	end
	
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		if UnitAffectingCombat(key) == val then
			result[key] = value
		end
	end
	
	return result	
end

BaseGroupHelper.AcceptableTargets = 
	{
		["Тренировочный манекен покорителя подземелий"] = 1
	}

function BaseGroup:Acceptable(party)
	function InnerAcceptable(target, party)
		for key,value in pairs(party) do
			if UnitThreatSituation(key, target) or UnitIsUnit( key, target.."target") then
				return 1
			end
		end
	end
	
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		if UnitAffectingCombat(key) and InnerAcceptable(key, party) then
			result[key] = value
		end
		if UnitAffectingCombat("player") and BaseGroupHelper.AcceptableTargets[UnitName(key)] then
			result[key] = value
		end
		if UnitIsUnit(key,"focus") then
			result[key] = value
		end
	end
	
	return result	
end





function distance(a,b)
	local x1,y1 = UnitPosition(a)
	local x2,y2 = UnitPosition(b)
	
	if x1 and x2 then
		local dx = x2 - x1
		local dy = y2 - y1
		return math.sqrt(dx*dx + dy*dy)
	end
	return nil
end

function distToParty(unit, party, range)
	local res = 0
	local totalDist = 0
	for key,value in pairs(party) do
		local d = distance(unit, key)
		if d and d < range then
			res = res + 1
			totalDist = totalDist + d
		end
	end
	return res, totalDist
end

function BaseGroup:BastForAoE(limit,range)
	local result = nil
	local bestC = 0
	local bestD = 0
	
	for key,value in pairs(self) do
		local c, d = distToParty(key, self, range)
		
		if c > bestC then
			result = value
			bestC = c
			bestD = d
		end
		if c == bestC and d < bestD then
			result = value
			bestC = c
			bestD = d		
		end		
	end 
	
	if bestC >= limit then
		return result
	end
end