MonkWW = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Отвар тигриной силы"] = 116740,
				["Удар восходящего солнца"] = 107428,
				["Рука-копье"] = 116705,
				["Дзуки"] = 100780,
				["Танцующий журавль"] = 101546,
				["Лапа тигра"] = 100787,
				["Нокаутирующий удар"] = 100784,
				["Сверкающая нефритовая молния"] = 117952,
				["Неистовые кулаки"] = 113656,
				["Ваятель ци"] = 175693,
			},
			["Buffs"] = {
				["Сила тигра"] = 125359,
				["Прок: Лапа тигра"] = 118864,
			},
			["Class"] = "MONK",
			["Buttons"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Run",
					},
					[2] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
						ToolTip = "On",
						GroupId = "AoE"
					},
					[3] = {
						Icon = "Interface\\Icons\\ABILITY_ROGUE_RECUPERATE",
						ToolTip = "On",
						GroupId = "Healing",
						default = 1
					},					
				},
		}

function MonkWW:OnUpdate(g, list, modes)
	if IsMounted() and UnitAura("player", "Северный боевой волк") == nil then return end
	
	if modes.Run == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	list:Cast( "Рука-копье", g.target:CanUse("Рука-копье"):CanInterrupt():Best() )

	if modes.AoE == "On" then
	
	else
		list:Cast( "Отвар тигриной силы", g.target:CanUse("Отвар тигриной силы"):Aura("Отвар тигриной силы", "mine", "self","inverse"):Best() )
	
		list:Cast( "Удар восходящего солнца", g.target:CanUse("Удар восходящего солнца"):Best() )
		list:Cast( "Лапа тигра", g.target:CanUse("Лапа тигра"):Aura("Сила тигра", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Ваятель ци", g.target:CanUse("Ваятель ци"):Best() )

		list:Cast( "Лапа тигра", g.target:CanUse("Лапа тигра"):Aura("Прок: Лапа тигра", "mine", "self"):Best() )
		list:Cast( "Неистовые кулаки", g.target:CanUse("Неистовые кулаки"):ChiLimit(4):Best() )		
		list:Cast( "Нокаутирующий удар", g.target:CanUse("Нокаутирующий удар"):ChiLimit(4):Best() )

		list:Cast( "Дзуки", g.target:CanUse("Дзуки"):Best() )
	end
	
	return list:Execute()
end	
		
TBRegister(MonkWW)
	