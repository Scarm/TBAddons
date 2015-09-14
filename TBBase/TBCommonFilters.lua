function BaseGroup:RangeHP(minHP, maxHP)
	local result = self:CreateDerived()
	
	-- костыль для Велари
	local maxPerc = select(15, UnitAura("boss1", "Аура презрения")) or 100
	
	for key,value in pairs(self) do
		local hp = 100 * (UnitHealth(key) / UnitHealthMax(key)) * ( 100 / maxPerc )
		if (minHP == nil or hp > minHP) and (maxHP ==nil or hp < maxHP) then
			result[key] = value
		end
	end
	
	return result
end

function BaseGroup:AvgRangeHP(minHP, maxHP)
	-- костыль для Велари
	local maxPerc = select(15, UnitAura("boss1", "Аура презрения")) or 100
	
	local totalHP = 0
	local cnt = 0
	for key,value in pairs(self) do
		local hp = 100 * (UnitHealth(key) / UnitHealthMax(key)) * ( 100 / maxPerc )
		totalHP = totalHP + hp
		cnt = cnt + 1
	end
	
	if cnt > 0 then
		totalHP = totalHP / cnt
		if (minHP == nil or totalHP > minHP) and (maxHP ==nil or totalHP < maxHP) then
			return self
		else
			return self:CreateDerived()
		end
	else
		return self
	end
end


function BaseGroup:HealthLimit(health)
	local hpp = 100 * UnitHealth("player") / UnitHealthMax("player")
	if hpp <= health then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:ManaLimit(mana)	
	local mpp = 100 * UnitPower("player") / UnitPowerMax("player")
	if mpp >= mana then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Count(c)	
	local cc = 0
	for key,value in pairs(self) do
		cc = cc + 1
	end
	
	if cc >= c then
		return self
	end
	return self:CreateDerived()
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

-- метод отбирает просевшие цели в зависимости от количества маны у кастера
-- этот метод - упрощение использования RangeHP для вариации маны
function BaseGroup:HealingRange(minHP, maxHP, minMana, maxMana)
	local result = self:CreateDerived()
	
	minMana = minMana or 0
	maxMana = maxMana or 100
	local mpp = 100 * UnitPower("player") / UnitPowerMax("player")
	
	if mpp < minMana then
		return result
	end
	
	local limit = minHP + (maxHP - minHP) * (mpp - minMana) / (maxMana - minMana)

	for key,value in pairs(self) do
		--local hp = 100 * (UnitHealth(key) + (UnitGetIncomingHeals(key) or 0)) / UnitHealthMax(key)
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

function BaseGroup:TBLastCast(key, yes)
	if IndicatorFrame.LastSpellTime == nil then
		IndicatorFrame.LastSpellTime = 0
	end
	
	if GetTime() > IndicatorFrame.LastSpellTime then
		IndicatorFrame.LastSpell = nil
	end

	
	
	local cond = IndicatorFrame.LastSpell and IndicatorFrame.LastSpell.Key == key
	if (cond and yes) or (not cond and not yes) then
		return self
	end
	
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		if UnitName(key) == IndicatorFrame.LastTarget then
			--print("Исключаем: ", key, "(",UnitName(key),")" )
		else
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


function BaseGroup:Charges(key, charges)
	local spell = IndicatorFrame.ByKey[key]
	
	local ch = GetSpellCharges(spell.RealId)
	if charges and ch >= charges then
		return self
	end
	
	return self:CreateDerived()
end

function BaseGroup:CanUse(key, ignoreChannel)
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
	  
	local startTime, duration = GetSpellCooldown(idx, book)
	local endTime = startTime + duration
	
	local lag = 50
	local delay = (GetCVar("maxSpellStartRecoveryOffset") - lag)/ 1000.0
	if delay < 0 then
		delay = 0
	end
	
	if GetTime() < endTime - delay then
        return result
    end
	
    if key ~= "Слово силы: Щит"	then
		if IsUsableSpell(idx, book) == false then
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
		if self:CheckTarget(key, idx, book, caster) then
			result[key] = value
		end	
	end
	
	return result	
end

function BaseGroup:IsFocus()
	if GetUnitName("focus") == nil then
		return self
	else
		if UnitIsUnit("focus","target") then
			return self
		end
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

function BaseGroup:AffectingCombat()
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		if UnitAffectingCombat(key) then
			result[key] = value
		end
	end
	
	return result	
end

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