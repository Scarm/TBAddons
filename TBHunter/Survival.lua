local bot = {
			["Talents"] = {
				["Рогатые гремучие змеи"] = 22274,
				["Залп"] = 22287,
				["Коварный выстрел"] = 22288,
				["Быстрая реакция"] = 19347,
				["Странник"] = 19348,
				["Часовой"] = 22286,
				["Стая воронов"] = 19357,
				["Верная цель"] = 22498,
				["Укус виверны"] = 22276,
				["Шквал"] = 22002,
				["Порыв"] = 22318,
				["Связующий выстрел"] = 22284,
				["Пронзающий выстрел"] = 22308,
				["Терпеливый снайпер"] = 21998,
				["Одинокий волк"] = 22279,
				["Камуфляж"] = 22499,
				["Черная стрела"] = 22497,
				["Устойчивая концентрация"] = 22501,
				["Разрывной выстрел"] = 22267,
				["На изготовку!"] = 22495,
			},
			["Name"] = "Выживание",
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
			["Id"] = 3,
			["Spells"] = {
				["Ярость орла"] = 203415,
				["Режущий удар"] = 185855,
				["Бомба-липучка"] = 191241,
				["Обходной удар"] = 202800,
				["Удар ящера"] = 186270,
				["Разделка туши"] = 187708,
				["Бросок топорика"] = 193265,
				["Взрывная ловушка"] = 191433,
				["Укус мангуста"] = 190928,
				["Стая воронов"] = 206505,
				["Намордник"] = 187707,
				["Гарпун"] = 190925,
        ["Метательные топоры"] = 200163,
        ["Граната пламени дракона"] = 194855,
			},
			["Buffs"] = {
				["Гарпун"] = 190927,
				["Взрывная ловушка"] = 13812,
				["Эхо мучений"] = 194608,
				["Укус змеи"] = 118253,
				["Ярость мангуста"] = 190931,
				["Рык"] = 2649,
				["Тактика Мок'Натала"] = 201081,
			},
			["Class"] = "HUNTER",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end



  list:Cast( "Намордник", g.target:CanUse("Намордник"):CanInterrupt():Best() )
  list:Cast( "Ярость орла", g.player:CanUse("Ярость орла"):Condition(g.target:InSpellRange("Удар ящера"):Any()):Aura("Ярость мангуста", "mine", "self", {time=1.5, bound="<"}):Best() )
	list:Cast( "Стая воронов", g.target:CanUse("Стая воронов"):Best() )
	list:Cast( "Взрывная ловушка", g.target:CanUse("Взрывная ловушка"):Toggle("AoE"):InSpellRange("Удар ящера"):Best() )
  list:Cast( "Граната пламени дракона", g.target:CanUse("Граната пламени дракона"):Toggle("Burst"):Best() )
	--list:Cast( "Взрывная ловушка", g.target:CanUse("Взрывная ловушка"):InSpellRange("Удар ящера"):Best() )

  list:Cast( "Удар ящера", g.target:CanUse("Удар ящера"):Aura("Тактика Мок'Натала", "mine", "self", {time=2, bound="<"}):Best() )

  list:Cast( "Укус мангуста", g.target:CanUse("Укус мангуста"):Charges("Укус мангуста", 3, 1.5):Best() )
  list:Cast( "Метательные топоры", g.target:CanUse("Метательные топоры"):Charges("Метательные топоры", 2, 1.5):Best() )
  list:Cast( "Обходной удар", g.target:CanUse("Обходной удар"):Best() )
  list:Cast( "Укус мангуста", g.target:CanUse("Укус мангуста"):Aura("Ярость мангуста", "mine", "self", {time=0.5, bound=">"}):Best() )




  list:Cast( "Режущий удар", g.target:CanUse("Режущий удар"):Aura("Режущий удар", "mine", "inverse", {time=3, bound=">"}):Best() )


  list:Cast( "Разделка туши", g.target:CanUse("Разделка туши"):Toggle("AoE"):Energy(">", 90):Best() )
  list:Cast( "Метательные топоры", g.target:CanUse("Метательные топоры"):Energy(">", 65):Best() )
  list:Cast( "Удар ящера", g.target:CanUse("Удар ящера"):Energy(">", 90):Best() )


	--list:Cast( "Увечье", g.target:CanUse("Увечье"):Best() )
	--list:Cast( "Раздавить", g.target:CanUse("Раздавить"):Best() )
	--list:Cast( "Взбучка", g.target:CanUse("Взбучка"):InSpellRange("Увечье"):Best() )
	--list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", "inverse"):Best() )
	--list:Cast( "Размах", g.target:CanUse("Размах"):InSpellRange("Увечье"):Best() )


	return list:Execute()
end


TBRegister(bot)
