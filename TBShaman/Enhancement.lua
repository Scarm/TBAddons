local bot = {
			["Talents"] = {
				["Тяжелый кулак"] = 22353,
				["Тотем вуду"] = 22127,
				["Обвал"] = 22148,
				["Щит молний"] = 22162,
				["Тотем ветряного порыва"] = 21963,
				["Гнев Воздуха"] = 22352,
				["Ливень"] = 22636,
				["Свирепый выпад"] = 22150,
				["Земляной шип"] = 22359,
				["Буран"] = 22137,
				["Стремительность предков"] = 19272,
				["Раскол"] = 22351,
				["Горячая рука"] = 22355,
				["Усиленный бурехлест"] = 22147,
				["Буря с градом"] = 22171,
				["Перерождение"] = 21969,
				["Тотем хватки земли"] = 19260,
				["Сокрушающая буря"] = 21973,
				["Перезарядка"] = 22149,
				["Тотем выброса тока"] = 19275,
				["Песнь ветра"] = 22354,
			},
			["Name"] = "Совершенствование",
			["Id"] = 2,
			["Spells"] = {
				["Дух дикого зверя"] = 51533,
				["Удар бури"] = 17364,
				["Вскипание лавы"] = 60103,
				["Молния"] = 187837,
				["Ледяное клеймо"] = 196834,
				["Сокрушающая молния"] = 187874,
				["Песнь ветра"] = 201898,
				["Гнев Воздуха"] = 197211,
				["Камнедробитель"] = 193786,
				["Язык пламени"] = 193796,
				["Тяжелый кулак"] = 201897,
				["Земляной шип"] = 188089,
			},
			["Buffs"] = {
				["Бурехлест"] = 195222,
				["Обвал"] = 202004,
				["Защитник Стражей Хиджала"] = 93341,
				["Видения будущего"] = 162913,
				["Вестник шторма"] = 201846,
				["Язык пламени"] = 194084,
				["Тяжелый кулак"] = 218825,
				["Ледяное клеймо_"] = 147732,
				["Горячая рука"] = 215785,
			},
			["Class"] = "SHAMAN",
      ["Buttons"] = {
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\Icons\\ABILITY_SEAL",
					["Name"] = "Stop",
				}, -- [1]
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					["Name"] = "AoE",
				}, -- [2]
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["Name"] = "Burst",
				}, -- [3]
			},
		}
function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end


  list:Cast( "Пронизывающий ветер", g.target:CanUse("Пронизывающий ветер"):CanInterrupt():Best() )

	list:Cast( "Тяжелый кулак", g.target:CanUse("Тяжелый кулак"):Aura("Тяжелый кулак", "mine", "inverse", "self"):Maelstrom("<", 100):Best() )
	list:Cast( "Тяжелый кулак", g.target:CanUse("Тяжелый кулак"):Aura("Тяжелый кулак", "mine", "inverse", "self"):Maelstrom("<", 50):Toggle("AoE"):Best() )
	list:Cast( "Камнедробитель", g.target:CanUse("Камнедробитель"):Talent("Обвал"):Aura("Обвал", "mine", "inverse", "self"):Best() )
	list:Cast( "Гнев Воздуха", g.player:CanUse("Гнев Воздуха"):Aura("Гнев Воздуха", "mine", "inverse", "self"):Condition(g.target:InSpellRange("Удар бури"):Any()):Best() )
	list:Cast( "Ледяное клеймо", g.target:CanUse("Ледяное клеймо"):Talent("Буря с градом"):Aura("Ледяное клеймо", "mine", "inverse", "self"):Best() )
	list:Cast( "Язык пламени", g.target:CanUse("Язык пламени"):Aura("Язык пламени", "mine", "inverse", "self"):Best() )
	list:Cast( "Сокрушающая молния", g.target:CanUse("Сокрушающая молния"):Condition(g.target:InSpellRange("Удар бури"):Any()):Talent("Сокрушающая буря"):Toggle("AoE"):Best() )
	list:Cast( "Земляной шип", g.target:CanUse("Земляной шип"):Best() )
	list:Cast( "Молния", g.target:CanUse("Молния"):Talent("Перезарядка"):Maelstrom(">", 50):Best() )
	list:Cast( "Песнь ветра", g.target:CanUse("Песнь ветра"):Best() )

	list:Cast( "Удар бури", g.target:CanUse("Удар бури"):Aura("Вестник шторма", "mine", "self"):Best() )
	list:Cast( "Вскипание лавы", g.target:CanUse("Вскипание лавы"):Aura("Горячая рука", "mine", "self"):Best() )
	list:Cast( "Сокрушающая молния", g.target:CanUse("Сокрушающая молния"):Condition(g.target:InSpellRange("Удар бури"):Any()):Toggle("AoE"):Best() )
	list:Cast( "Удар бури", g.target:CanUse("Удар бури"):Maelstrom(">", 60):Best() )

	list:Cast( "Камнедробитель", g.target:CanUse("Камнедробитель"):Best() )
	list:Cast( "Язык пламени", g.target:CanUse("Язык пламени"):Best() )
	list:Cast( "Тяжелый кулак", g.target:CanUse("Тяжелый кулак"):Best() )

	list:Cast( "Исцеляющий всплеск", g.player:CanUse("Исцеляющий всплеск"):HP("<", 70, "self"):Best() )
  --list:Cast( "Молния", g.target:CanUse("Молния"):Best() )
	return list:Execute()
end


TBRegister(bot)
