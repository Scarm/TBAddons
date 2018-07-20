local bot = {
			["Talents"] = {
				["Управление гневом"] = 21204,
				["Удар громовержца"] = 22800,
				["Сотрясание земли"] = 22631,
				["Рев дракона"] = 23260,
				["Луженая глотка"] = 22395,
				["Никогда не сдаваться"] = 23261,
				["Предельный шаг"] = 22629,
				["Устрашение"] = 22384,
				["Лютая месть"] = 22378,
				["Верная победа"] = 15774,
				["Месть"] = 22544,
				["Охрана"] = 22409,
				["Наказание"] = 15759,
				["Неукротимость"] = 23096,
				["Жесткий отпор"] = 22406,
				["Опустошитель"] = 23099,
				["Поддержка"] = 22488,
				["Неудержимая сила"] = 22626,
				["В гущу боя"] = 15760,
				["Сокрушитель"] = 22401,
				["Трескучий гром"] = 22373,
			},
			["Name"] = "Защита",
			["Id"] = 3,
			["Spells"] = {
				["Сокрушение"] = 20243,
				["Реванш"] = 6572,
				["Деморализующий крик"] = 1160,
				["Зуботычина"] = 6552,
				["Мощный удар щитом"] = 23922,
				["Стойкость к боли"] = 190456,
				["Ударная волна"] = 46968,
				["Ни шагу назад"] = 12975,
				["Рев дракона"] = 118000,
				["Удар грома"] = 6343,
				["Боевой крик"] = 6673,
				["Блок щитом"] = 2565,
				["Героический бросок"] = 57755,
				["Победный раж"] = 34428,
				["Верная победа"] = 202168,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Наказание"] = 275335,
				["Ударная волна"] = 132168,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Камень поиска маны"] = 227723,
				["Блок щитом"] = 132404,
				["Знак битвы"] = 186403,
				["Глубокие раны"] = 115767,
				["Секрет Сефуза"] = 208052,
				["Реванш"] = 5302,
			},
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
					Type = "spell",
					Spell = 46968, -- Ударная волна
				},
				{
					Type = "spell",
					Spell = 118000, -- Рев дракона
					talent = 23260,
				},
				{
					["Type"] = "trigger",
					["Icon"] = 132362,
					["Name"] = "Def",
				}, -- [3]
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
			},
		}

function bot:AddCommonBuff(buffs)
	print("AddCommonBuff")
	buffs["AP"] = buffs["AP"] or {}
	buffs["AP"]["Боевой крик"] = 6673
end

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt(modes.selector.Interrupt):Best() )
	list:Cast( "Ударная волна", g.target:CanUse("Ударная волна"):Enabled("Ударная волна"):InSpellRange("Сокрушение"):Best() )
	list:Cast( "Рев дракона", g.target:CanUse("Рев дракона"):Enabled("Рев дракона"):InSpellRange("Сокрушение"):Best() )
	list:Cast( "Верная победа", g.target:CanUse("Верная победа"):HP("<", 70, "self"):Best() )
	list:Cast( "Победный раж", g.target:CanUse("Победный раж"):HP("<", 70, "self"):Best() )

	if g.player:AffectingCombat(true):MinHP() then
		list:Cast( "Деморализующий крик", g.target:CanUse("Деморализующий крик"):HP("<", 50, "self"):Best() )

		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Toggle("Def"):Condition(g.target:CanUse("Мощный удар щитом"):Any()):Aura("Блок щитом", "mine", "self", "inverse"):Best() )
		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Toggle("Def"):Charges("Блок щитом", 2):Aura("Блок щитом", "mine", "self", "inverse"):Best() )

		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Toggle("Def"):Energy(">", 70):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Toggle("Def"):Aura("Стойкость к боли", "mine", "self", {time=2, bound="<"}):Best() )
		--list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Месть: стойкость к боли", "mine", "self", {time=1, bound="<"}):Best() )
		--list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Чешуя дракона", "mine", "self", {time=1, bound="<"}):Best() )
		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Aura("Блок щитом", "mine", "self", "inverse"):HP("<", 50, "self"):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):HP("<", 50, "self"):Best() )
	end

	list:Cast( "Удар грома", g.target:CanUse("Удар грома"):Toggle("AoE"):InSpellRange("Сокрушение"):Best() )
	list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
	list:Cast( "Реванш", g.target:CanUse("Реванш"):Aura("Реванш", "mine", "self"):Condition(g.target:InSpellRange("Сокрушение"):Any()):Best() )
	list:Cast( "Реванш", g.target:CanUse("Реванш"):Condition(g.target:InSpellRange("Сокрушение"):Any()):Energy(">", 70):Best() )
	list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )
	list:Cast( "Героический бросок", g.target:CanUse("Героический бросок"):Best() )

	--list:Cast( "Боевой крик", g.party:CanUse("Боевой крик"):CommonBuff("Боевой крик"):Best() )
	--[[
	list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):CanUse("Ярость Нелтариона"):Enabled("Ярость Нелтариона"):Condition(g.target:InSpellRange("Сокрушение"):Any()):Best() )
	list:Cast( "Ярость Нелтариона", g.player:CanUse("Ярость Нелтариона"):Enabled("Ярость Нелтариона"):Condition(g.target:InSpellRange("Сокрушение"):Any()):Best() )

	if g.player:AffectingCombat(true):MinHP() then

		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Condition(g.target:CanUse("Мощный удар щитом"):Any()):Aura("Блок щитом", "mine", "self", "inverse"):Best() )
		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Charges("Блок щитом", 2):Aura("Блок щитом", "mine", "self", "inverse"):Best() )

		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Energy(">", 80):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Стойкость к боли", "mine", "self", {time=1, bound="<"}):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Месть: стойкость к боли", "mine", "self", {time=1, bound="<"}):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Чешуя дракона", "mine", "self", {time=1, bound="<"}):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):HP("<", 50, "self"):Best() )
		list:Cast( "Деморализующий крик", g.target:CanUse("Деморализующий крик"):InSpellRange("Сокрушение"):HP("<", 50, "self"):Best() )
	end

	--]]

	return list:Execute()
end


TBRegister(bot)
