local bot = {
			["Talents"] = {
				["Управление гневом"] = 21204,
				["Удар громовержца"] = 22625,
				["Дополнительный выпад"] = 22407,
				["Превосходство"] = 22360,
				["Удвоенное время"] = 22409,
				["Ударная волна"] = 22373,
				["Травма"] = 22397,
				["Предельный шаг"] = 22627,
				["Неустрашимость"] = 22624,
				["Размашистые удары"] = 22371,
				["Кровопускание"] = 22626,
				["Титаническая мощь"] = 22399,
				["Аватара"] = 19138,
				["Опустошитель"] = 21667,
				["Смертельный прием"] = 22393,
				["Сосредоточенная ярость"] = 22800,
				["Оборонительная стойка"] = 22628,
				["Боевой запал"] = 22380,
				["Смертельное спокойствие"] = 22394,
				["Добивание"] = 22383,
				["Второе дыхание"] = 15757,
			},
			["Name"] = "Оружие",
			["Buttons"] = {
				{
					Type = "trigger",
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					Name = "Stop",
				},
				{
					Type = "trigger",
					Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					Name = "AoE",
				},
				{
					Type = "trigger",
					Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					Name = "Burst",
				},
				{
					Type = "spell",
					Spell = 46968, -- Ударная волна
					talent = 22373, --Ударная волна
				},
			},
			["Id"] = 1,
			["Spells"] = {
				["Рывок"] = 100,
				["Удар громовержца"] = 107570,
				["Кровопускание"] = 772,
				["Удар колосса"] = 167105,
				["Мощный удар"] = 1464,
				["Смертельный удар"] = 12294,
				["Превосходство"] = 7384,
				["Ударная волна"] = 46968,
				["Опустошитель"] = 152277,
				["Миротворец"] = 209577,
				["Боевой крик"] = 1719,
				["Вихрь клинков"] = 227847,
				["Рассекающий удар"] = 845,
				["Вихрь"] = 1680,
				["Казнь"] = 163201,
				["Победный раж"] = 34428,
			},
			["Buffs"] = {
				["Рывок"] = 105771,
				["Травма"] = 215537,
				["Смертельное ранение"] = 115804,
				["Удар громовержца"] = 132169,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Удар колосса"] = 208086,
				["Превосходство!"] = 60503,
			},
			["Class"] = "WARRIOR",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end




	list:Cast( "Ударная волна", g.player:CanUse("Ударная волна"):Enabled("Ударная волна"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Best() )

	list:Cast( "Опустошитель", g.target:CanUse("Опустошитель"):Toggle("Burst"):Best() )
	list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Talent("Опустошитель"):SpellCooldown("Опустошитель", ">", 55):Toggle("Burst"):Best() )
	list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Talent("Опустошитель", false):Toggle("Burst"):Best() )
	list:Cast( "Миротворец", g.target:CanUse("Миротворец"):Toggle("Burst"):Best() )
	list:Cast( "Вихрь клинков", g.player:CanUse("Вихрь клинков"):Toggle("Burst"):Best() )


	list:Cast( "Кровопускание", g.target:CanUse("Кровопускание"):Aura("Кровопускание", "mine", "inverse", {time=3, bound=">"}):Best() )
	list:Cast( "Удар колосса", g.target:CanUse("Удар колосса"):Aura("Удар колосса", "mine", "inverse"):Best() )
	list:Cast( "Удар громовержца", g.target:CanUse("Удар громовержца"):Best() )


	if modes.toggle.AoE then
		list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Toggle("AoE"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Energy(">", 70):Best() )

		list:Cast( "Рассекающий удар", g.target:CanUse("Рассекающий удар"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Toggle("AoE"):Best() )
		list:Cast( "Вихрь", g.player:CanUse("Вихрь"):Condition(g.target:InSpellRange("Мощный удар"):Any()):Aura("Рассекающий удар", "mine", "self"):Toggle("AoE"):Best() )
	else
		list:Cast( "Победный раж", g.target:CanUse("Победный раж"):HP("<", 70, "self"):Best() )
		list:Cast( "Смертельный удар", g.target:Talent("Смертельный прием"):CanUse("Смертельный удар"):Charges("Смертельный удар", 2, 1.5):Best() )
		list:Cast( "Превосходство", g.target:CanUse("Превосходство"):Aura("Превосходство!", "mine", "self", {time=5, bound="<"}):Best() )
		list:Cast( "Казнь", g.target:CanUse("Казнь"):Aura("Удар колосса", "mine"):Energy(">", 70):Best() )
		list:Cast( "Мощный удар", g.target:CanUse("Мощный удар"):Energy(">", 70):Best() )

		list:Cast( "Превосходство", g.target:CanUse("Превосходство"):Best() )
		list:Cast( "Казнь", g.target:CanUse("Казнь"):Aura("Удар колосса", "mine"):Energy(">", 40):Best() )
		list:Cast( "Смертельный удар", g.target:CanUse("Смертельный удар"):Aura("Удар колосса", "mine"):Best() )
		list:Cast( "Казнь", g.target:CanUse("Казнь"):Aura("Удар колосса", "mine"):Best() )
		list:Cast( "Мощный удар", g.target:CanUse("Мощный удар"):Aura("Удар колосса", "mine"):Best() )
	end

	return list:Execute()
end


TBRegister(bot)
