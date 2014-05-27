RogueCombat ={
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Веер клинков"] = 51723,
				["Внезапный удар"] = 8676,
				["Потрошение"] = 2098,
				["Коварный удар"] = 1752,
				["Заживление ран"] = 73651,
				["Рваная рана"] = 1943,
				["Мясорубка"] = 5171,
				["Пробивающий удар"] = 84617,
				["Незаметность"] = 1784,
			},
			["Buffs"] = {
			},
			["Class"] = "ROGUE",
		}
	
function BaseGroup:ComboPoints(points)
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		
		if GetComboPoints("player", key)>=points then
			result[key] = value
		end
	end
	
	return result
end

function BaseGroup:Target()
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		
		if UnitIsUnit("target",key) then
			result[key] = value
			return result
		end
	end
	return result
end	

function RogueCombat:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if GetShapeshiftForm() == 0 then
		list:Cast( "Незаметность", g.player:CanUse("Незаметность"):MinHP() )
	end	
	
	// удар-стартер
	list:Cast( "Внезапный удар", g.targets:AutoAttacking("true"):CanUse("Внезапный удар"):MinHP() )
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	

	
	--list:Cast( "Пробивающий удар", g.targets:CanUse("Пробивающий удар"):Target():Aura("Пробивающий удар", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Пробивающий удар", g.target:CanUse("Пробивающий удар"):Aura("Пробивающий удар", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Мясорубка", g.player:CanUse("Мясорубка"):Aura("Мясорубка", "mine", "self", "inverse", 3):MinHP() )
	list:Cast( "Заживление ран", g.player:CanUse("Заживление ран"):RangeHP(0, 80):Aura("Заживление ран", "mine", "self", "inverse", 3):MinHP() )
	
	--list:Cast( "Рваная рана", targets:CanUse("Рваная рана"):ComboPoints(5):Aura("Рваная рана", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Потрошение", g.targets:CanUse("Потрошение"):ComboPoints(5):MinHP() )

	list:Cast( "Коварный удар", g.targets:CanUse("Коварный удар"):MinHP() )
	
	return list:Execute()
end	
		
TBRegister(RogueCombat)
	