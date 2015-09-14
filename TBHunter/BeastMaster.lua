BeastMaster = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Тяжелая артиллерия"] = 175687,
				["Залп"] = 2643,
				["Команда \"Взять!\""] = 34026,
				["Убийственный выстрел"] = 53351,
				["Верный выстрел"] = 56641,
				["Сконцентрированный огонь"] = 82692,
				["Чародейский выстрел"] = 3044,
				["Встречный выстрел"] = 147362,
				["Стая воронов"] = 131894,
				["Воскрешение питомца"] = 982,
			},
			["Class"] = "HUNTER",
			["Buffs"] = {
				["Бешенство"] = 19615,
				["Охотничий азарт"] = 34720,
			},
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
				},
		}

function BaseGroup:HunterFocus(focus)	
	if UnitPower("player") >= focus then
		return self
	end
	return self:CreateDerived()
end
		
function BeastMaster:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end

	list:Cast( "Встречный выстрел", g.target:CanUse("Встречный выстрел"):CanInterrupt():Best() )

	list:Cast( "Сконцентрированный огонь", g.player:CanUse("Сконцентрированный огонь"):Aura("Бешенство", "mine", "self"):Best() )	
	list:Cast( "Тяжелая артиллерия", g.target:CanUse("Тяжелая артиллерия"):Best() )
	list:Cast( "Стая воронов", g.target:CanUse("Стая воронов"):Best() )
	list:Cast( "Убийственный выстрел", g.target:CanUse("Убийственный выстрел"):Best() )
	list:Cast( "Команда \"Взять!\"", g.target:CanUse("Команда \"Взять!\""):Best() )

	list:Cast( "Чародейский выстрел", g.target:CanUse("Чародейский выстрел"):Aura("Охотничий азарт", "mine", "self"):Best() )	
	list:Cast( "Чародейский выстрел", g.target:CanUse("Чародейский выстрел"):HunterFocus(90):Best() )	
	list:Cast( "Верный выстрел", g.target:CanUse("Верный выстрел"):Best() )
	
	return list:Execute()
end
		
		
		
TBRegister(BeastMaster)