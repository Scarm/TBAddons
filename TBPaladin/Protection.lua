local bot = {
			["Talents"] = {
				["Серафим"] = 21202,
				["Эгида Света"] = 22564,
				["Длань защитника"] = 22705,
				["Первый мститель"] = 22431,
				["Праведный защитник"] = 21201,
				["Правосудие Света"] = 22438,
				["Последний бой"] = 17601,
				["Кавалерист"] = 22434,
				["Благословение защиты от заклинаний"] = 22433,
				["Кулак правосудия"] = 22179,
				["Бастион Света"] = 22604,
				["Щит небес"] = 22428,
				["Благословенный молот"] = 22558,
				["Последний защитник"] = 22645,
				["Слепящий свет"] = 21811,
				["Освященный молот"] = 22430,
				["Рыцарский суд"] = 22594,
				["Рыцарь-тамплиер"] = 21795,
				["Аура воздаяния"] = 22435,
				["Освященная земля"] = 17609,
				["Покаяние"] = 22180,
			},
			["Name"] = "Защита",
			["Buttons"] = {
        [1] = {
					Type = "trigger",
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					Name = "Stop",
				},
				[2] = {
					Type = "trigger",
					Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					Name = "AoE",
				},
				[3] = {
					Type = "spell",
					Spell = 209202, -- Око Тира
				},
			},
			["Id"] = 2,
			["Spells"] = {
				["Молот праведника"] = 53595,
				["Щит праведника"] = 53600,
				["Правосудие"] = 20271,
				["Укор"] = 96231,
				["Молот правосудия"] = 853,
				["Освящение"] = 26573,
				["Вспышка Света"] = 19750,
				["Длань расплаты"] = 62124,
				["Щит мстителя"] = 31935,
				["Свет защитника"] = 184092,
				["Благословенный молот"] = 204019,
				["Око Тира"] = 209202,
			},
			["Class"] = "PALADIN",
			["Buffs"] = {
				["Защитник рамкахенов"] = 93337,
				["Освящение"] = 188370,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Освящение_"] = 204242,
				["Щит праведника"] = 132403,
				["Правосудие Света"] = 196941,
				["Благословенный молот"] = 204301,
				["Аура воздаяния"] = 203797,
			},
		}


function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	list:Cast( "Укор", g.target:CanUse("Укор"):CanInterrupt():Best() )
	list:Cast( "Око Тира", g.target:CanUse("Око Тира"):InSpellRange("Молот правосудия"):Enabled("Око Тира"):Best() )
  list:Cast( "Освящение", g.player:CanUse("Освящение"):Moving(false):Condition(g.target:InSpellRange("Молот правосудия"):Any()):Toggle("AoE"):Best() )

  list:Cast("Щит праведника", g.target:CanUse("Щит праведника"):Charges("Щит праведника", 3, 0.5):Best() )
  list:Cast("Щит праведника", g.target:CanUse("Щит праведника"):Charges("Щит праведника", 2, 0.5):HP("<", 60, "self"):Aura("Щит праведника", "mine", "self", "inverse"):Best() )
  list:Cast("Щит праведника", g.target:CanUse("Щит праведника"):HP("<", 40, "self"):Aura("Щит праведника", "mine", "self", "inverse"):Best() )
  list:Cast("Свет защитника", g.player:CanUse("Свет защитника"):HP("<", 50, "self"):Best() )

  list:Cast( "Щит мстителя", g.target:CanUse("Щит мстителя"):Best() )
  list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )
  list:Cast( "Благословенный молот", g.target:CanUse("Благословенный молот"):Condition(g.target:InSpellRange("Молот правосудия"):Any()):Best() )
  list:Cast( "Молот праведника", g.target:CanUse("Молот праведника"):Best() )

	return list:Execute()
end


TBRegister(bot)
