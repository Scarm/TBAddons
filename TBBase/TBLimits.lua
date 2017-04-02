function BaseGroup:HP(bound, hp, isSelf)
	-- костыль для Велари
	local maxPerc = select(15, UnitAura("boss1", "Аура презрения")) or 100

	if isSelf then
		local val = 100 * (UnitHealth("player") / UnitHealthMax("player")) * ( 100 / maxPerc )
		if (bound == "<" and val <= hp) or (bound == ">" and val >= hp) then
			return self
		end
		return self:CreateDerived()
	end

	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local val = 100 * (UnitHealth(key) / UnitHealthMax(key)) * ( 100 / maxPerc )
		if (bound == "<" and val <= hp) or (bound == ">" and val >= hp) then
			result[key] = value
		end
	end
	return result
end

function BaseGroup:Mana(bound, mana)
	local mpp = 100 * UnitPower("player") / UnitPowerMax("player")
	if (bound == "<" and mpp <= mana) or (bound == ">" and mpp >= mana) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Energy(bound, energy)
	local e = UnitPower("player")
	if (bound == "<" and e <= energy) or (bound == ">" and e >= energy) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:HolyPower(points)
	if UnitPower("player", 9) >= points then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:ArcaneCharges(points)
	if UnitPower("player", SPELL_POWER_ARCANE_CHARGES) >= points then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:Maelstrom(bound, points)
	local e =  UnitPower("player", SPELL_POWER_MAELSTROM)
	if (bound == "<" and e <= points) or (bound == ">" and e >= points) then
		return self
	end
	return self:CreateDerived()
end


function BaseGroup:Shards(bound, points)
	local e =  UnitPower("player", SPELL_POWER_SOUL_SHARDS)
	if (bound == "<" and e <= points) or (bound == ">" and e >= points) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:SoulShards(points)
	if UnitPower("player", 7) >= points then
		return self
	end
	return self:CreateDerived()
end


function BaseGroup:Pain(points)
	if UnitPower("player", SPELL_POWER_PAIN) >= points then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:ComboPoints(bound, points)
	local result = self:CreateDerived()
	for key,value in pairs(self) do
		local cp = GetComboPoints("player", key)
		if (bound == "<" and cp <= points) or (bound == ">" and cp >= points) then
			result[key] = value
		end
	end
	return result
end
