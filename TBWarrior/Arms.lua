local bot = {
			["Name"] = "Оружие",
			["Buttons"] = {
				[1] = {
					Type = "trigger",
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					Name = "Stop",
				},
				[2] = {
					Type = "trigger",
					Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					Name = "Burst",
				},
			},
			["Id"] = 1,
			["Spells"] = {
				["Рывок"] = 100,
				["Удар громовержца"] = 107570,
				["Кровопускание"] = 772,
				["Удар колосса"] = 167105,
				["Мощный удар"] = 1464,
				["Смертельный удар"] = 12294,
			},
			["Buffs"] = {
				["Рывок"] = 105771,
				["Травма"] = 215537,
				["Смертельное ранение"] = 115804,
				["Удар громовержца"] = 132169,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Удар колосса"] = 208086,
			},
			["Class"] = "WARRIOR",
		}
		
function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end	
	if modes.toggle.Stop then 
		return
	end
	
	list:Cast( "Кровопускание", g.target:CanUse("Кровопускание"):Aura("Кровопускание", "mine", "inverse"):Best() )
	list:Cast( "Удар колосса", g.target:CanUse("Удар колосса"):Aura("Удар колосса", "mine", "inverse"):Best() )
	list:Cast( "Удар громовержца", g.target:CanUse("Удар громовержца"):Best() )
	
	list:Cast( "Смертельный удар", g.target:CanUse("Смертельный удар"):Charges("Смертельный удар", 2, 1.5):Best() )
	list:Cast( "Мощный удар", g.target:CanUse("Мощный удар"):Energy(">", 70):Best() )
	
	list:Cast( "Смертельный удар", g.target:CanUse("Смертельный удар"):Aura("Удар колосса", "mine"):Best() )
	list:Cast( "Мощный удар", g.target:CanUse("Мощный удар"):Aura("Удар колосса", "mine"):Best() )
	
	return list:Execute()
end

		
TBRegister(bot)