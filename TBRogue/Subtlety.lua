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
				["Смерть с небес"] = 21188,
				["Окутывающая тень"] = 22336,
				["Удар из теней"] = 22334,
				["Умысел"] = 22335,
				["Выживает сильнейший"] = 22114,
				["Мастер теней"] = 22132,
				["Неуловимость"] = 22122,
				["Предчувствие"] = 19240,
			},
			["Name"] = "Скрытность",
			["Id"] = 3,
			["Spells"] = {

				["Алый фиал"] = 185311,
				["Ночной клинок"] = 195452,
				["Удар Тьмы"] = 185438,
				["Метка смерти"] = 137619,
				["Потрошение"] = 196819,
				["Клинок мрака"] = 200758,
				["Незаметность"] = 1784,
        ["Пинок"] = 1766,
        ["Бросок сюрикэна"] = 114014,
        ["Удар в спину"] = 53,
        ["Символы смерти"] = 212283,
				["Танец теней"] = 185313,
			},
			["Buffs"] = {
				["Защитник Стражей Хиджала"] = 93341,
				["Удар из теней"] = 196958,
				["Эхо мучений"] = 194608,
				["Ночные кошмары"] = 206760,
				["Камень Шаманов: Дух Волка"] = 155347,
			},
			["Class"] = "ROGUE",
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
  list:Cast( "Пинок", g.target:CanUse("Пинок"):CanInterrupt():Best() )
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Condition(g.target:CanUse("Бросок сюрикэна"):Best()):Aura("Незаметность", "mine", "inverse"):Best() )
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Aura("Незаметность", "mine", "inverse"):Moving(true):Best() )
  list:Cast( "Символы смерти", g.player:CanUse("Символы смерти"):Condition(g.target:CanUse("Бросок сюрикэна"):Best()):Aura("Символы смерти", "mine", "inverse","self"):Best() )

	list:Cast( "Танец теней", g.player:CanUse("Танец теней"):AffectingCombat(true):Energy(">",75):Aura("Символы смерти", "mine", "inverse","self", {time=5, bound=">"}):Best() )

  list:Cast( "Ночной клинок", g.target:CanUse("Ночной клинок"):ComboPoints(">", 5):Aura("Ночной клинок", "mine", "inverse"):Best() )
  list:Cast( "Потрошение", g.target:CanUse("Потрошение"):ComboPoints(">", 9):Best() )

  list:Cast( "Алый фиал", g.player:CanUse("Алый фиал"):HP("<", 65, "self"):Best() )

  list:Cast( "Удар Тьмы", g.target:CanUse("Удар Тьмы"):Best() )
	list:Cast( "Метка смерти", g.target:CanUse("Метка смерти"):ComboPoints("<", 5):Best() )
	list:Cast( "Клинок мрака", g.target:CanUse("Клинок мрака"):Energy(">",45):Aura("Символы смерти", "mine","self", {time=7, bound=">"}):Best() )
  list:Cast( "Удар в спину", g.target:CanUse("Удар в спину"):Energy(">",45):Aura("Символы смерти", "mine","self", {time=7, bound=">"}):Best() )
	list:Cast( "Клинок мрака", g.target:CanUse("Клинок мрака"):Energy(">",80):Best() )
  list:Cast( "Удар в спину", g.target:CanUse("Удар в спину"):Energy(">",80):Best() )

	return list:Execute()
end


TBRegister(bot)
