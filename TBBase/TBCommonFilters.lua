function BaseGroup:Condition(value)
	if value then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Count(value)
	local c = 0
	for key,value in pairs(self) do
		c = c + 1
	end
	if c >= value then
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
function BaseGroup:SpellCooldown(key, bound, value)
	local spellID = IndicatorFrame.Spec.Spells[key]
	local startTime, duration = GetSpellCooldown(spellID)

	local left = 0
	if startTime > 0 then
		left = startTime + duration - GetTime()
	end

	if (bound == "<" and left <= value) or (bound == ">" and left >= value) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:SpellOverlayed(key)
	local spellID = IndicatorFrame.Spec.Spells[key]

	if IsSpellOverlayed(spellID) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:InSpellRange(key, inverse)
	local spell = TBGetSpell(key)
	local result = self:CreateDerived()

	for k,v in pairs(self) do
		if (IsSpellInRange(GetSpellInfo(spell.baseSpell), k) == 1) == (inverse == nil) then
			result[k] = v
		end
	end

	return result
end

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

function BaseGroup:CanInterrupt(part)
	part = part or "last"

	local function IsCast(key, part)
		local st = select(4,UnitCastingInfo(key))
		local et = select(5,UnitCastingInfo(key))
		local ni = select(8,UnitCastingInfo(key))


		if not et then
			return false
		end
		if ni then
			return false
		end
		if (GetTime() + 0.2 > et / 1000) then
			return false
		end
		local mid = (st + et) / 2

		if part == "last" then
			return GetTime() + 0.7 > et / 1000
		end
		if part == "first" then
			return true
		end
		if part == "mid" then
			return GetTime() > mid / 1000
		end
	end

	local function IsChannel(key)
		local ni = select(7,UnitChannelInfo(key))
		local name = UnitChannelInfo(key)
		return name and not ni
	end

	local result = self:CreateDerived()
	for key,value in pairs(self) do
		if IsCast(key, part) or IsChannel(key) then
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


function BaseGroup:CommonBuff(key)
	local buffs = IndicatorFrame.CommonBuffs or {}
	local group = nil
	for gr, list in pairs(buffs) do
		for k,v in pairs(list) do
			if k==key then
				group = list
			end
		end
	end

	local auras = {}
	for k,v in pairs(group) do
		table.insert(auras, k)
	end

	return self:Aura(auras, "inverse")
end
