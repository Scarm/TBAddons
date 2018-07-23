local bot = {
			["Talents"] = {
				["Управление гневом"] = 21204,
				["Удар громовержца"] = 22789,
				["Второе дыхание"] = 15757,
				["Удвоенное время"] = 19676,
				["Внезапная смерть"] = 22360,
				["Военная машина"] = 22624,
				["Предельный шаг"] = 22627,
				["Боевой запал"] = 22489,
				["Верная победа"] = 22372,
				["Кровопускание"] = 19138,
				["Кровопролитие"] = 22380,
				["Сопутствующий ущерб"] = 22392,
				["Бесстрашие"] = 22407,
				["Рассекающий удар"] = 22362,
				["Рассекатель черепов"] = 22371,
				["Опустошитель"] = 21667,
				["Добивание"] = 22394,
				["Оборонительная стойка"] = 22628,
				["Смертельное спокойствие"] = 22399,
				["Аватара"] = 22397,
				["Миротворец"] = 22391,
			},
			["Name"] = "Оружие",
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
				{
					Type = "spell",
					Spell = 100, -- Рывок
				},
				{
					["Type"] = "selector",
					["Name"] = "Interrupt",
					["Values"] = {
						{
							["Value"] = "first",
							["Icon"] = 876914,
						}, -- [1]
						{
							["Value"] = "mid",
							["Icon"] = 876916,
						}, -- [2]
						{
							["Value"] = "last",
							["Icon"] = 876915,
							["default"] = 1,
						}, -- [3]
					},
				}, -- [4]
				{
					["Type"] = "trigger",
					["Icon"] = 135915,
					["Name"] = "Heal",
					checked = 1
				}, -- [5]

			},
			["Id"] = 1,
			["Spells"] = {
				["Вихрь"] = 1680,
				["Удар громовержца"] = 107570,
				["Зуботычина"] = 6552,
				["Превосходство"] = 7384,
				["Удар колосса"] = 167105,
				["Вихрь клинков"] = 227847,
				["Рассекающий удар"] = 845,
				["Героический бросок"] = 57755,
				["Рывок"] = 100,
				["Размашистые удары"] = 260708,
				["Верная победа"] = 202168,
				["Мощный удар"] = 1464,
				["Аватара"] = 107574,
				["Рассекатель черепов"] = 260643,
				["Кровопускание"] = 772,
				["Боевой крик"] = 6673,
				["Смертельный удар"] = 12294,
				["Миротворец"] = 262161,
				["Победный раж"] = 34428,
				["Казнь"] = 163201,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Глубокие раны"] = 262115,
				["Удар колосса"] = 208086,
				["Знак битвы"] = 186403,
				["Смертельное ранение"] = 115804,
				["Ускорение"] = 214128,
				["Вой Ингвара"] = 214802,
				["Секрет Сефуза"] = 208052,
				["Внезапная смерть"] = 52437,
			},
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end


	-- [[
	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt("first"):Best() )
	list:Cast( "Рывок", g.target:CanUse("Рывок"):Enabled("Рывок"):Best() )
	list:Cast( "Верная победа", g.target:CanUse("Верная победа"):HP("<", 70, "self"):Toggle("Heal"):Best() )
	list:Cast( "Победный раж", g.target:CanUse("Победный раж"):HP("<", 70, "self"):Toggle("Heal"):Best() )

	list:Cast( "Аватара", g.player:CanUse("Аватара"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Toggle("Burst"):Best() )
	list:Cast( "Вихрь клинков", g.player:CanUse("Вихрь клинков"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Toggle("Burst"):Best() )

	list:Cast( "Кровопускание", g.target:CanUse("Кровопускание"):Aura("Удар колосса", "mine", "inverse"):Aura("Кровопускание", "mine", "inverse", {time=3, bound=">"}):Best() )
	list:Cast( "Удар колосса", g.target:CanUse("Удар колосса"):Best() )
	list:Cast( "Миротворец", g.target:CanUse("Миротворец"):InSpellRange("Смертельный удар"):Best() )
	list:Cast( "Рассекатель черепов", g.target:CanUse("Рассекатель черепов"):Energy("<", 70):Best() )
	list:Cast( "Превосходство", g.target:CanUse("Превосходство"):Aura("Превосходство", "mine", "inverse", "self", {stacks=2, bound=">"}):Best() )
	list:Cast( "Рассекающий удар", g.target:CanUse("Рассекающий удар"):InSpellRange("Мощный удар"):Toggle("AoE"):Best() )
	list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Energy(">", 50):Toggle("AoE"):Best() )

	list:Cast( "Смертельный удар", g.target:CanUse("Смертельный удар"):Best() )
	list:Cast( "Рассекатель черепов", g.target:CanUse("Рассекатель черепов"):Best() )

	list:Cast( "Удар громовержца", g.target:CanUse("Удар громовержца"):Best() )
	list:Cast( "Казнь", g.target:CanUse("Казнь"):Energy(">", 40):Best() )
	list:Cast( "Мощный удар", g.target:CanUse("Мощный удар"):Energy(">", 60):Best() )
	list:Cast( "Героический бросок", g.target:CanUse("Героический бросок"):Best() )

	list:Cast( "Боевой крик", g.party:CanUse("Боевой крик"):CommonBuff("Боевой крик"):Best() )
	--]]
	--[[


	if modes.toggle.AoE then
		--list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Toggle("AoE"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Energy(">", 70):Best() )

		list:Cast( "Рассекающий удар", g.target:CanUse("Рассекающий удар"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Toggle("AoE"):Best() )
		--list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Aura("Рассекающий удар", "mine", "self"):Toggle("AoE"):Best() )
	end

		--]]
	return list:Execute()
end


TBRegister(bot)
