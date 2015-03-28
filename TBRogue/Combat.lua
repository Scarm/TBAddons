RogueCombat = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Внезапный удар"] = 8676,
				["Кровавый вихрь"] = 121411,
				["Бросок"] = 121733,
				["Пробивающий удар"] = 84617,
				["Коварный удар"] = 1752,
				["Незаметность"] = 1784,
				["Отравляющий укол"] = 5938,
				["Шквал клинков"] = 13877,
				["Потрошение"] = 2098,
				["Заживление ран"] = 73651,
				["Мясорубка"] = 5171,
				["Пинок"] = 1766,
				["Метка смерти"] = 137619,
			},
			["Class"] = "ROGUE",
			["Buffs"] = {
			},
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

function RogueCombat:OnUpdate(g, list, modes)
	if IsMounted() then return end

	if GetShapeshiftForm() == 0 and g.target:CanUse("Бросок"):Best() then
		list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Best() )
	end	
	
	-- удар-стартер
	list:Cast( "Внезапный удар", g.targets:AutoAttacking("true"):CanUse("Внезапный удар"):Best() )
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	list:Cast( "Пинок", g.targets:CanUse("Пинок"):CanInterrupt():Best() )
	
	list:Cast( "Метка смерти", g.target:CanUse("Метка смерти"):Best() )

	list:Cast( "Пробивающий удар", g.target:CanUse("Пробивающий удар"):Aura("Пробивающий удар", "mine", nil, "inverse", 3):Best() )
	list:Cast( "Мясорубка", g.player:CanUse("Мясорубка"):Aura("Мясорубка", "mine", "self", "inverse", 3):Best() )
	list:Cast( "Заживление ран", g.player:CanUse("Заживление ран"):RangeHP(0, 80):Aura("Заживление ран", "mine", "self", "inverse", 3):Best() )
	
	--list:Cast( "Рваная рана", targets:CanUse("Рваная рана"):ComboPoints(5):Aura("Рваная рана", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Потрошение", g.targets:CanUse("Потрошение"):ComboPoints(5):Best() )

	list:Cast( "Коварный удар", g.targets:CanUse("Коварный удар"):Best() )
	
	return list:Execute()
end	
		
TBRegister(RogueCombat)
	