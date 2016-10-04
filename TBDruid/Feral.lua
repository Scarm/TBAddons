local bot = {
			["Talents"] = {
				["Лунное вдохновение"] = 22365,
				["Массовое оплетение"] = 18576,
				["Душа леса"] = 21708,
				["Мощное оглушение"] = 21778,
				["Кровавые когти"] = 21649,
				["Родство со стражем"] = 22158,
				["Запах крови"] = 22364,
				["Дикий рев"] = 21702,
				["Обновление"] = 19283,
				["Воплощение: Король джунглей"] = 21705,
				["Родство с балансом"] = 22163,
				["Рваные раны"] = 21711,
				["Астральный скачок"] = 18570,
				["Момент ясности"] = 21653,
				["Наставление Элуны"] = 22370,
				["Жестокий удар когтями"] = 21646,
				["Родство с исцелением"] = 22159,
				["Хищник"] = 22363,
				["Стремительный рывок"] = 18571,
				["Саблезуб"] = 21714,
				["Тайфун"] = 18577,
			},
			["Name"] = "Сила зверя",
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
        ["Дикий рев"] = 52610,
        ["Бешенство Пеплошкурой"] = 210722,
				["Воплощение: Король джунглей"] = 102543,
				["Свирепый укус"] = 22568,
				["Лобовая атака"] = 106839,
				["Лунный огонь"] = 8921,
				["Целительное прикосновение"] = 5185,
				["Облик медведя"] = 5487,
				["Взбучка"] = 106830,
				["Размах"] = 106785,
				["Крадущийся зверь"] = 5215,
				["Глубокая рана"] = 1822,
				["Тигриное неистовство"] = 5217,
				["Полоснуть"] = 5221,
				["Облик кошки"] = 768,
				["Разорвать"] = 1079,
			},
			["Buffs"] = {
				["Глубокая рана_"] = 163505,
				["Лунный огонь"] = 164812,
				["Покровительство Пеплошкурой"] = 210655,
				["Открытые раны"] = 210670,
				["Ясность мысли"] = 135700,
				["Стремительность хищника"] = 69369,
				["Защитник гильдии"] = 97341,
				["Кровавые когти"] = 145152,
				["Энергия Пеплошкурой"] = 210583,
				["Глубокая рана"] = 155722,
				["Знак застрельщика"] = 186401,
				["Зараженные раны"] = 58180,
				["Камень поиска маны"] = 227723,
			},
			["Class"] = "DRUID",
		}

    function bot:OnUpdate(g, list, modes)
    	if IsMounted() then return end
    	if modes.toggle.Stop then
    		return
    	end

    	list:Cast( "Лобовая атака", g.target:CanUse("Лобовая атака"):CanInterrupt():Best() )

      list:Cast( "Бешенство Пеплошкурой", g.target:CanUse("Бешенство Пеплошкурой"):Energy("<", 70):Aura("Энергия Пеплошкурой", "mine", "self","inverse"):ComboPoints("<",2):Best() )
      list:Cast( "Тигриное неистовство", g.player:CanUse("Тигриное неистовство"):Energy("<", 20):Best() )

      list:Cast( "Целительное прикосновение",
        g.player
        :CanUse("Целительное прикосновение")
        :Aura("Стремительность хищника", "mine", "self", {time=2, bound=">"})
        :Condition(g.target:ComboPoints(">",5):Best())
        :Best() )

      list:Cast( "Дикий рев", g.player:CanUse("Дикий рев"):Aura("Дикий рев", "mine", "inverse", {time=3, bound=">"}):Condition( g.target:ComboPoints(">",5):Any() ):Best() )
      list:Cast( "Разорвать", g.target:CanUse("Разорвать"):Aura("Разорвать", "mine", "inverse", {time=3, bound=">"}):ComboPoints(">",5):Best() )

      list:Cast( "Свирепый укус", g.target:Talent("Саблезуб"):CanUse("Свирепый укус"):Energy(">", 50):ComboPoints(">",5):Best() )
      list:Cast( "Свирепый укус", g.target:HP("<",25):CanUse("Свирепый укус"):Energy(">", 50):ComboPoints(">",5):Best() )

      list:Cast( "Глубокая рана", g.target:CanUse("Глубокая рана"):Aura("Глубокая рана", "mine", "inverse", {time=3, bound=">"}):Best() )
      list:Cast( "Глубокая рана", g.target:CanUse("Глубокая рана"):Aura("Кровавые когти", "mine", "self"):Best() )

      list:Cast( "Взбучка", g.target:CanUse("Взбучка"):Toggle("AoE"):Aura("Взбучка", "mine", "inverse"):Best() )
      list:Cast( "Размах", g.target:CanUse("Размах"):Toggle("AoE"):ComboPoints("<",4):Best() )

      list:Cast( "Полоснуть", g.target:CanUse("Полоснуть"):Energy(">", 70):ComboPoints("<",4):Best() )
      list:Cast( "Полоснуть", g.target:CanUse("Полоснуть"):Aura("Разорвать", "mine", "inverse", {time=3, bound=">"}):ComboPoints("<",4):Best() )
      list:Cast( "Полоснуть", g.target:CanUse("Полоснуть"):Condition(g.player:CanUse("Тигриное неистовство"):Any()):ComboPoints("<",4):Best() )


    	return list:Execute()
    end


    TBRegister(bot)
