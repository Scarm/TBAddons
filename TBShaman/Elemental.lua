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
				["Тотем выброса тока"] = 19275,
				["Перерождение"] = 21969,
				["Перезарядка"] = 22149,
				["Сокрушающая буря"] = 21973,
				["Тотем хватки земли"] = 19260,
				["Буря с градом"] = 22171,
				["Песнь ветра"] = 22354,
			},
			["Name"] = "Стихии",
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
			["Id"] = 1,
			["Spells"] = {
				["Выброс лавы"] = 51505,
				["Порыв ветра"] = 192063,
				["Удар духов стихии"] = 117014,
				["Молния"] = 188196,
				["Тотем выброса тока"] = 192058,
				["Землетрясение"] = 61882,
				["Повелитель тотемов"] = 210643,
				["Цепная молния"] = 188443,
				["Огненный шок"] = 188389,
				["Земной шок"] = 8042,
        ["Пронизывающий ветер"] = 57994,
				["Исцеляющий всплеск"] = 8004,
				["Ледяная ярость"] = 210714,
				["Ледяной шок"] = 196840,
			},
			["Class"] = "SHAMAN",
			["Buffs"] = {
				["Удар духов стихии: скорость"] = 173183,
				["Тотем огнезола"] = 210658,
				["Тотем бури"] = 210652,
				["Средоточие стихий"] = 16246,
				["Камень Шаманов: Бушующий ветер"] = 155344,
				["Защитник Стражей Хиджала"] = 93341,
				["Тотем попутного ветра"] = 210659,
				["Волна лавы"] = 77762,
				["Видения будущего"] = 162913,
				["Бушующий ветер"] = 155339,
				["Тотем резонанса"] = 202192,
				["Азарт"] = 142073,
			},
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end


  list:Cast( "Пронизывающий ветер", g.target:CanUse("Пронизывающий ветер"):CanInterrupt():Best() )

	if g.player:AffectingCombat(true):MinHP() then
		list:Cast( "Повелитель тотемов", g.target:CanUse("Повелитель тотемов"):Aura("Тотем огнезола", "mine", "inverse","self"):Best() )
	end

	list:Cast( "Ледяная ярость", g.target:CanUse("Ледяная ярость"):Best() )
  list:Cast( "Огненный шок", g.target:CanUse("Огненный шок"):Aura("Огненный шок", "mine", "inverse", {time=3, bound=">"}):Best() )

	list:Cast( "Земной шок", g.target:CanUse("Земной шок"):CanUse("Выброс лавы"):Maelstrom(">", 88):Best() )
	list:Cast( "Земной шок", g.target:CanUse("Земной шок"):Maelstrom(">", 92):Best() )
	list:Cast( "Земной шок", g.target:CanUse("Земной шок"):Maelstrom(">", 84):LastCast("Молния", true):Best() )

	list:Cast( "Удар духов стихии", g.target:CanUse("Удар духов стихии"):Best() )
	list:Cast( "Ледяной шок", g.target:CanUse("Ледяной шок"):Aura("Ледяная ярость", "mine", "self"):Best() )
  list:Cast( "Выброс лавы", g.target:CanUse("Выброс лавы"):Best() )

	list:Cast( "Исцеляющий всплеск", g.player:CanUse("Исцеляющий всплеск"):HP("<", 70, "self"):Best() )
	list:Cast( "Цепная молния", g.target:CanUse("Цепная молния"):Toggle("AoE"):Best() )
	list:Cast( "Молния", g.target:CanUse("Молния"):Best() )
	return list:Execute()
end


TBRegister(bot)
