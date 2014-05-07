MonkBrewmaster = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Нокаутирующий удар"] = 100784,
				["Дзуки"] = 100780,
				["Неистовые кулаки"] = 113656,
				["Лапа тигра"] = 100787,
			},
			["Class"] = "MONK",
			["Buffs"] = {
				["Сила тигра"] = 125359,
			},
		}
		
function MonkBrewmaster:OnUpdate(player, party, focus, targets, list)
	if IsMounted() then return end
	if not UnitAffectingCombat("player") then
		return
	end
	
	list:Cast( "Лапа тигра", targets:CanUse("Лапа тигра"):Aura("Сила тигра", "mine", "self", "inverse", 3):MinHP() )
	list:Cast( "Нокаутирующий удар", targets:CanUse("Нокаутирующий удар"):MinHP() )
	list:Cast( "Дзуки", targets:CanUse("Дзуки"):MinHP() )
	
	return list:Execute()
end	
		
TBRegister(MonkBrewmaster)