local bot = {
			["Talents"] = {
				["Умиротворяющая тьма"] = 22128,
				["Мастер боя"] = 19234,
				["Теневая концентрация"] = 22333,
				["Метка смерти"] = 22133,
				["Ночной ловец"] = 22331,
				["Сковывающая тьма"] = 22131,
				["Мастер скрытности"] = 19233,
				["Увертка"] = 22332,
				["Неутомимость"] = 19241,
				["Клинок мрака"] = 19235,
				["Расчетливость"] = 19239,
				["Расторопность"] = 19249,
				["Обман смерти"] = 22123,
				["Предчувствие"] = 19240,
				["Неуловимость"] = 22122,
				["Мастер теней"] = 22132,
				["Удар из теней"] = 22334,
				["Умысел"] = 22335,
				["Выживает сильнейший"] = 22114,
				["Окутывающая тень"] = 22336,
				["Смерть с небес"] = 21188,
			},
			["Name"] = "Головорез",
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
			["Id"] = 2,
			["Spells"] = {
				["Пронзить насквозь"] = 2098,
				["Призрачный удар"] = 196937,
				["Бросок костей"] = 193316,
				["Метка смерти"] = 137619,
				["Выстрел из пистоли"] = 185763,
				["Пинок"] = 1766,
				["Алый фиал"] = 185311,
				["Удар саблей"] = 193315,
				["Шквал клинков"] = 13877,
        ["Внезапный удар"] = 8676,
        ["Незаметность"] = 1784,
			},
			["Class"] = "ROGUE",
			["Buffs"] = {
				["Зарытое сокровище"] = 199600,
				["Великая битва"] = 193358,
				["Эхо мучений"] = 194608,
				["Защитник Стражей Хиджала"] = 93341,
				["Замечательная возможность"] = 195627,
				["Бортовые залпы"] = 193356,
				["Истинный азимут"] = 193359,
			},
		}


function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end
  list:Cast( "Пинок", g.target:CanUse("Пинок"):CanInterrupt():Best() )
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Condition(g.target:CanUse("Выстрел из пистоли"):Best()):Aura("Незаметность", "mine", "inverse"):Best() )
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Aura("Незаметность", "mine", "inverse"):Moving(true):Best() )

  list:Cast( "Пронзить насквозь", g.target:CanUse("Пронзить насквозь"):Aura("Незаметность", "mine", "inverse"):ComboPoints(">", 5):Best() )

  list:Cast( "Алый фиал", g.player:CanUse("Алый фиал"):HP("<", 65, "self"):Best() )

  list:Cast( "Внезапный удар", g.target:CanUse("Внезапный удар"):Best() )
	list:Cast( "Метка смерти", g.target:CanUse("Метка смерти"):ComboPoints("<", 5):Best() )
  list:Cast( "Призрачный удар", g.target:CanUse("Призрачный удар"):Aura("Призрачный удар", "mine", "inverse"):Best() )
  list:Cast( "Выстрел из пистоли", g.target:CanUse("Выстрел из пистоли"):Aura("Замечательная возможность", "mine", "self"):Best() )
  list:Cast( "Удар саблей", g.target:CanUse("Удар саблей"):Best() )

	return list:Execute()
end


TBRegister(bot)
