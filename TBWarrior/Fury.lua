local bot = {
			["Talents"] = {
				["Рассечение плоти"] = 22396,
				["Управление гневом"] = 22402,
				["Удар громовержца"] = 23093,
				["Рев дракона"] = 22398,
				["Резня"] = 22383,
				["Удвоенное время"] = 19676,
				["Вихрь клинков"] = 22400,
				["Внезапная смерть"] = 22381,
				["Военная машина"] = 22632,
				["Предельный шаг"] = 22627,
				["Разъяренный берсерк"] = 19140,
				["Верная победа"] = 22625,
				["Боевая раскраска"] = 22382,
				["Кровопролитие"] = 22393,
				["Неистовый удар сплеча"] = 23372,
				["Яростный рывок"] = 23097,
				["Бесконечная ярость"] = 22633,
				["Прорыв блокады"] = 16037,
				["Безудержная энергия"] = 22405,
				["Внутренняя ярость"] = 22379,
				["Свежее мясо"] = 22491,
			},
			["Name"] = "Неистовство",
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
				}, -- [5]
			},
			["Id"] = 2,
			["Spells"] = {
				["Вихрь"] = 190411,
				["Казнь"] = 5308,
				["Героический прыжок"] = 6544,
				["Неистовый удар сплеча"] = 100130,
				["Боевой крик"] = 6673,
				["Вихрь клинков"] = 46924,
				["Яростный выпад"] = 85288,
				["Безрассудство"] = 1719,
				["Рывок"] = 100,
				["Прорыв блокады"] = 280772,
				["Кровожадность"] = 23881,
				["Буйство"] = 184367,
				["Героический бросок"] = 57755,
				["Удар громовержца"] = 107570,
			},
			["Buffs"] = {
				["Рывок"] = 105771,
				["Вихрь"] = 85739,
				["Неистовый удар сплеча"] = 202539,
				["Ускорение"] = 214128,
				["Секрет Сефуза"] = 208052,
				["Плач Ангербоды"] = 214807,
				["Яростный рывок"] = 202225,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Знак битвы"] = 186403,
				["Прорыв блокады"] = 280773,
				["Вой Ингвара"] = 214802,
				["Исступление"] = 184362,
				["Стенания Свалы"] = 214803,
			},
			["Class"] = "WARRIOR",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end
	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt("first"):Best() )
	list:Cast( "Рывок", g.target:CanUse("Рывок"):Enabled("Рывок"):Best() )

	list:Cast( "Неистовый удар сплеча", g.target:CanUse("Неистовый удар сплеча"):Aura("Неистовый удар сплеча", "mine", "self", "inverse", {time=3, bound=">"}):Best() )

	list:Cast( "Верная победа", g.target:CanUse("Верная победа"):HP("<", 70, "self"):Toggle("Heal"):Best() )
	list:Cast( "Победный раж", g.target:CanUse("Победный раж"):HP("<", 70, "self"):Toggle("Heal"):Best() )

	list:Cast( "Безрассудство", g.player:CanUse("Безрассудство"):Condition(g.target:InSpellRange("Кровожадность"):Any()):Toggle("Burst"):Energy("<", 30):Best() )
	list:Cast( "Вихрь клинков", g.player:CanUse("Вихрь клинков"):Condition(g.target:InSpellRange("Кровожадность"):Any()):Toggle("Burst"):Energy("<", 30):Best() )

	list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Condition(g.target:InSpellRange("Яростный выпад"):Any()):Aura("Вихрь", "mine", "self", "inverse"):Toggle("AoE"):Best() )

	list:Cast( "Прорыв блокады", g.target:CanUse("Прорыв блокады"):Best() )
	list:Cast( "Буйство", g.target:CanUse("Буйство"):Best() )

	list:Cast( "Казнь", g.target:CanUse("Казнь"):Best() )
	list:Cast( "Яростный выпад", g.target:CanUse("Яростный выпад"):Charges("Яростный выпад", 2, 3):Best() )
	list:Cast( "Кровожадность", g.target:CanUse("Кровожадность"):Best() )
	list:Cast( "Яростный выпад", g.target:CanUse("Яростный выпад"):Best() )

	--list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Aura("Пушечное ядро", "mine", "self"):Best() )
	list:Cast( "Неистовый удар сплеча", g.target:CanUse("Неистовый удар сплеча"):Best() )

	list:Cast( "Удар громовержца", g.target:CanUse("Удар громовержца"):Best() )
	list:Cast( "Героический бросок", g.target:CanUse("Героический бросок"):Best() )

	return list:Execute()
end


TBRegister(bot)
