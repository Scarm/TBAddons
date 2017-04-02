local bot = {
			["Talents"] = {
				["Сила отравителя"] = 21186,
				["Теневая концентрация"] = 22333,
				["Метка смерти"] = 22133,
				["Ночной ловец"] = 22331,
				["Предчувствие"] = 19240,
				["Неутомимость"] = 19241,
				["Смерть с небес"] = 21188,
				["Расчетливость"] = 19239,
				["Расторопность"] = 19249,
				["Похищающий жизнь яд"] = 22340,
				["Удавление"] = 22341,
				["Увертка"] = 22332,
				["Коварный план"] = 22338,
				["Внутреннее кровотечение"] = 22115,
				["Обман смерти"] = 22123,
				["Мучительный яд"] = 22343,
				["Кровоизлияние"] = 22339,
				["Мастер ядоварения"] = 22337,
				["Выживает сильнейший"] = 22114,
				["Неуловимость"] = 22122,
				["Пускание крови"] = 22344,
			},
			["Name"] = "Ликвидация",
			["Id"] = 1,
			["Spells"] = {
				["Метка смерти"] = 137619,
				["Расправа"] = 1329,
				["Пинок"] = 1766,
				["Кровоизлияние"] = 16511,
				["Алый фиал"] = 185311,
				["Мучительный яд"] = 200802,
				["Смертоносный яд"] = 2823,
				["Гаррота"] = 703,
				["Отравление"] = 32645,
				["Рваная рана"] = 1943,
				["Отравленный нож"] = 185565,
        ["Незаметность"] = 1784,
			},
			["Buffs"] = {
				["Расторопность"] = 193538,
				["Защитник Стражей Хиджала"] = 93341,
				["Мучительный яд"] = 200803,
				["Смертоносный яд"] = 2818,
				["Эхо мучений"] = 194608,
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
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Condition(g.target:CanUse("Отравленный нож"):Best()):Aura("Незаметность", "mine", "inverse"):Best() )
  list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Aura("Незаметность", "mine", "inverse"):Moving(true):Best() )

  list:Cast( "Рваная рана", g.target:CanUse("Рваная рана"):ComboPoints(">", 5):Aura("Рваная рана", "mine", "inverse"):Best() )
  list:Cast( "Отравление", g.target:CanUse("Отравление"):ComboPoints(">", 8):Best() )

  list:Cast( "Алый фиал", g.player:CanUse("Алый фиал"):HP("<", 80, "self"):Best() )

  list:Cast( "Гаррота", g.target:CanUse("Гаррота"):Aura("Гаррота", "mine", "inverse"):Best() )
	list:Cast( "Метка смерти", g.target:CanUse("Метка смерти"):ComboPoints("<", 5):Best() )
  list:Cast( "Кровоизлияние", g.target:CanUse("Кровоизлияние"):Aura("Кровоизлияние", "mine", "inverse"):Best() )
  list:Cast( "Расправа", g.target:CanUse("Расправа"):Best() )

	return list:Execute()
end


TBRegister(bot)
