MonkWindwalker = {
			["Unique"] = {
			},
			["Id"] = 3,
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
		
function MonkWindwalker:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if not UnitAffectingCombat("player") then
		return
	end
	
	list:Cast( "Лапа тигра", g.targets:CanUse("Лапа тигра"):Aura("Сила тигра", "mine", "self", "inverse", 3):MinHP() )
	list:Cast( "Нокаутирующий удар", g.targets:CanUse("Нокаутирующий удар"):MinHP() )
	list:Cast( "Дзуки", g.targets:CanUse("Дзуки"):MinHP() )
	
	return list:Execute()
end	
		
TBRegister(MonkWindwalker)