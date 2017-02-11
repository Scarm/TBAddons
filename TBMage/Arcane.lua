local bot = {
			["Talents"] = {
				["Сверхновая"] = 22453,
				["Щит маны"] = 22906,
				["Наполнение силой"] = 22467,
				["Усиление"] = 22461,
				["Ледяной заслон"] = 22471,
				["Эрозия"] = 22474,
				["Темпоральное смещение"] = 22907,
				["Чародейский шар"] = 21145,
				["Воздушный поток"] = 22443,
				["Перегрузка"] = 21630,
				["Кольцо мороза"] = 22448,
				["Резонанс"] = 22470,
				["Слова могущества"] = 22464,
				["Мерцание"] = 22442,
				["Колдовской поток"] = 22447,
				["Руна мощи"] = 22445,
				["Волшебный фамилиар"] = 22458,
				["Зеркальное изображение"] = 22444,
				["Нестабильная магия"] = 22449,
				["Буря Пустоты"] = 22455,
				["Временной поток"] = 21144,
			},
			["Name"] = "Тайная магия",
			["Id"] = 1,
			["Spells"] = {
				["Чародейский обстрел"] = 44425,
				["Мощь тайной магии"] = 12042,
				["Чародейская вспышка"] = 30451,
				["Чародейские стрелы"] = 5143,
				["Наполнение силой"] = 205032,
				["Прилив сил"] = 12051,
				["Призматический барьер"] = 235450,
				["Зеркальное изображение"] = 55342,
				["Величие разума"] = 205025,
				["Чародейский взрыв"] = 1449,
			},
			["Buffs"] = {
				["Защитник Стражей Хиджала"] = 93341,
				["Видение Бездны"] = 201410,
				["Чародейские стрелы!"] = 79683,
				["Критический удар"] = 165832,
				["Темпоральное смещение"] = 236298,
				["Волшебный фамилиар"] = 210126,
				["Темпоральное смещение_"] = 236299,
			},
			["Class"] = "MAGE",
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
					Spell = 235450, -- Призматический барьер
				},
			},
			["Macro"] = {
				--["selfFS"] = "/cast [@player] Огненный столб",
			--	["selfMet"] = "/cast [@player] Метеор",
			},
		}


		function bot:OnUpdate(g, list, modes)
			if IsMounted() then return end
			if modes.toggle.Stop then
				return
			end


			list:Cast( "Антимагия", g.target:CanUse("Антимагия"):CanInterrupt("first"):Best() )
			list:Cast( "Призматический барьер", g.player:CanUse("Призматический барьер"):Enabled("Призматический барьер"):Aura("Призматический барьер", "mine", "self", "inverse"):Best() )

			list:Cast( "Чародейские стрелы", g.target:CanUse("Чародейские стрелы"):Mana("<", 90):ArcaneCharges(2):Best() )
			list:Cast( "Чародейские стрелы", g.target:CanUse("Чародейские стрелы"):Mana("<", 90):ArcaneCharges(1):LastCast("Чародейская вспышка", true):Best() )

			list:Cast( "Чародейские стрелы", g.target:CanUse("Чародейские стрелы"):Mana("<", 90):ArcaneCharges(3):Best() )
			list:Cast( "Чародейские стрелы", g.target:CanUse("Чародейские стрелы"):Mana("<", 90):ArcaneCharges(2):LastCast("Чародейская вспышка", true):Best() )

			list:Cast( "Чародейский обстрел", g.target:CanUse("Чародейский обстрел"):Mana("<", 90):ArcaneCharges(2):Best() )
			list:Cast( "Чародейский обстрел", g.target:CanUse("Чародейский обстрел"):Mana("<", 90):ArcaneCharges(1):LastCast("Чародейская вспышка", true):Best() )

			list:Cast( "Чародейский обстрел", g.target:CanUse("Чародейский обстрел"):ArcaneCharges(3):Best() )
			list:Cast( "Чародейский обстрел", g.target:CanUse("Чародейский обстрел"):ArcaneCharges(2):LastCast("Чародейская вспышка", true):Best() )

			--list:Cast( "Чародейский обстрел", g.target:CanUse("Чародейский обстрел"):Mana("<", 90):ArcaneCharges(3):Best() )

			list:Cast( "Чародейский взрыв", g.target:CanUse("Чародейский взрыв"):Toggle("AoE"):Best() )
			list:Cast( "Чародейская вспышка", g.target:CanUse("Чародейская вспышка"):Best() )
			return list:Execute()
		end


		TBRegister(bot)
