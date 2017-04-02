local bot = {
			["Talents"] = {
				["Вой ужаса"] = 22476,
				["Вытягивание жизни"] = 19279,
				["Темный пакт"] = 19288,
				["Абсолютная порча"] = 21180,
				["Стремительный бег"] = 19291,
				["Гримуар жертвоприношения"] = 19295,
				["Жатва душ"] = 22046,
				["Демонический круг"] = 19280,
				["Посадка семян"] = 19292,
				["Призрачная сингулярность"] = 19281,
				["Изваяние души"] = 19284,
				["Болезненные мучения"] = 22090,
				["Посредник душ"] = 19293,
				["Усиленный жизнеотвод"] = 22088,
				["Заражение"] = 22044,
				["Гримуар верховной власти"] = 21182,
				["Блуждающий дух"] = 19290,
				["Шкура демона"] = 22047,
				["Гибельная хватка"] = 22040,
				["Лик тлена"] = 19285,
				["Гримуар служения"] = 19294,
			},
			["Name"] = "Колдовство",
			["Id"] = 1,
			["Spells"] = {
				["Агония"] = 980,
				["Жизнеотвод"] = 1454,
				["Вытягивание жизни"] = 63106,
				["Семя порчи"] = 27243,
				["Нестабильное колдовство"] = 30108,
				["Порча"] = 172,
				["Похищение души"] = 198590,
        ["Блуждающий дух"] = 48181,
				["Урожай душ"] = 216698,
			},
			["Buffs"] = {
				["Ливень шлака"] = 177083,
				["Расплавленный металл"] = 177081,
				["Порча"] = 146739,
				["Защитник Стражей Хиджала"] = 93341,
				["Усиленный жизнеотвод"] = 235156,
				["Поглощение души"] = 108366,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Время настало!"] = 194627,
				["Нестабильное колдовство"] = 233490,
				["Жнец Мертвого Ветра"] = 216708,
				["Замученные души"] = 216695,
			},
			["Class"] = "WARLOCK",
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

	list:Cast( "Похищение души", g.target:CanUse("Похищение души"):Moving(false):HP("<", 50, "self"):Best() )
  list:Cast( "Жизнеотвод", g.player:CanUse("Жизнеотвод"):Condition(g.target:CanUse("Порча"):Best()):Talent("Усиленный жизнеотвод"):Aura("Усиленный жизнеотвод", "mine", "inverse", {time=3, bound=">"}):Best() )
	list:Cast( "Урожай душ", g.player:CanUse("Урожай душ"):Aura("Жнец Мертвого Ветра", "mine", "self","inverse"):Aura("Замученные души", "mine", "self"):Toggle("Burst"):Best() )
	list:Cast( "Семя порчи", g.target:CanUse("Семя порчи"):Aura("Семя порчи", "mine","inverse"):LastCast("Семя порчи", false):Toggle("AoE"):Moving(false):Best() )
	list:Cast( "Агония", g.target:CanUse("Агония", {"Похищение души"}):Aura("Агония", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Блуждающий дух", g.target:CanUse("Блуждающий дух"):Moving(false):Aura("Блуждающий дух", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Порча", g.target:CanUse("Порча"):Aura("Порча", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Похищение души", g.target:CanUse("Похищение души"):Moving(false):HP("<", 80, "self"):Best() )
	list:Cast( "Нестабильное колдовство", g.target:CanUse("Нестабильное колдовство"):Shards(">",4):Moving(false):Best() )
	list:Cast( "Нестабильное колдовство", g.target:CanUse("Нестабильное колдовство"):Shards(">",3):LastCast("Нестабильное колдовство", false,"total"):Moving(false):Best() )
  list:Cast( "Жизнеотвод", g.player:CanUse("Жизнеотвод"):Condition(g.target:CanUse("Порча"):Best()):Mana("<",70):Best() )
  list:Cast( "Похищение души", g.target:CanUse("Похищение души"):Moving(false):Best() )

	return list:Execute()
end


TBRegister(bot)
