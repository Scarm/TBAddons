local bot = {
			["Name"] = "Баланс",
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
					Type = "trigger",
					Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					Name = "Burst",
				},
				[4] = {
					Type = "spell",
					Spell = 18562, -- Быстрое восстановление
				},
				[5] = {
					Type = "spell",
					talent = 22386, -- Воин Элуны
					Spell = 202425, -- Воин Элуны
				},
				[6] = {
					Type = "spell",
					Spell = 191034, -- Звездопад
				},
			},
			["Id"] = 1,
			["Spells"] = {
				["Облик лунного совуха"] = 24858,
				["Походный облик"] = 783,
				["Астральное единение"] = 202359,
				["Лунный огонь"] = 8921,
				["Целительное прикосновение"] = 5185,
				["Солнечный гнев"] = 190984,
				["Лунный удар"] = 194153,
				["Быстрое восстановление"] = 18562,
				["Воплощение: Избранный Элуны"] = 102560,
				["Звездное могущество"] = 197637,
				["Звездный поток"] = 78674,
				["Ярость Элуны"] = 202770,
				["Звездопад"] = 191034,
				["Солнечный огонь"] = 93402,
				["Звездная вспышка"] = 202347,
				["Воин Элуны"] = 202425,
				["Полная луна"] = 202771,
				["Новолуние"] = 202767,
				["Полумесяц"] = 202768,
				["Парад планет"] = 194223,
			},
			["Buffs"] = {
				["Солнечное могущество"] = 164545,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Знак Призрачной Луны"] = 159678,
				["Защитник гильдии"] = 97341,
				["Лунный огонь"] = 164812,
				["Лунное могущество"] = 164547,
				["Солнечный огонь"] = 164815,

			},
			["Talents"] = {
				["Родство с исцелением"] = 22159,
				["Массовое оплетение"] = 18576,
				["Душа леса"] = 18580,
				["Мощное оглушение"] = 21778,
				["Родство со стражем"] = 22157,
				["Ярость Элуны"] = 21648,
				["Обновление"] = 19283,
				["Природное равновесие"] = 21655,
				["Астральное единение"] = 18585,
				["Благословение Древних"] = 22390,
				["Воин Элуны"] = 22386,
				["Звездная вспышка"] = 22388,
				["Астральный скачок"] = 18570,
				["Родство с силой зверя"] = 22155,
				["Стремительный рывок"] = 18571,
				["Падающие звезды"] = 22389,
				["Звездный лорд"] = 22387,
				["Воплощение: Избранный Элуны"] = 18579,
				["Сила Природы"] = 22385,
				["Смещение звезд"] = 21193,
				["Тайфун"] = 18577,
			},
			["Class"] = "DRUID",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	if GetShapeshiftForm() == 4 then

		--list:Cast( "Звездопад", g.target:CanUse("Звездопад"):Enabled("Звездопад"):LastCast("Звездопад", false):Best() )
		list:Cast( "Воин Элуны", g.player:CanUse("Воин Элуны"):Enabled("Воин Элуны"):Best() )

		--list:Cast( "Полная луна", g.target:CanUse("Полная луна"):Moving(false):Best() )

		list:Cast( "Воплощение: Избранный Элуны", g.player:CanUse("Воплощение: Избранный Элуны"):Energy(">", 40):Toggle("Burst"):Moving(false):Best() )
		list:Cast( "Парад планет", g.player:CanUse("Парад планет"):Energy(">", 40):Moving(false):Toggle("Burst"):Best() )

		list:Cast( "Полная луна", g.target:CanUse("Полная луна"):Charges("Полная луна", 3, 3):Moving(false):Best() )
		list:Cast( "Новолуние", g.target:CanUse("Новолуние"):Charges("Новолуние", 3, 3):Moving(false):Best() )
		list:Cast( "Полумесяц", g.target:CanUse("Полумесяц"):Charges("Полумесяц", 3, 3):Moving(false):Best() )

		list:Cast( "Звездная вспышка", g.target:CanUse("Звездная вспышка"):Aura("Звездная вспышка", "mine", "inverse"):LastCast("Звездная вспышка", false):Best() )
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", "inverse"):Best() )
		list:Cast( "Солнечный огонь", g.target:CanUse("Солнечный огонь"):Aura("Солнечный огонь", "mine", "inverse"):Best() )

		if modes.toggle.AoE then
			list:Cast( "Звездопад", g.target:CanUse("Звездопад"):Moving(false):Best() )

			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Moving(false):Best() )
			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )

			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self", {stacks=2, bound=">"}):Moving(false):Best() )
			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self", {stacks=2, bound=">"}):Moving(false):Best() )

			list:Cast( "Полная луна", g.target:CanUse("Полная луна"):Moving(false):Best() )
			list:Cast( "Новолуние", g.target:CanUse("Новолуние"):Moving(false):Best() )
			list:Cast( "Полумесяц", g.target:CanUse("Полумесяц"):Moving(false):Best() )

			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Moving(false):Best() )
			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Moving(false):Best() )
		else
			list:Cast( "Звездный поток", g.target:CanUse("Звездный поток"):Moving(false):Best() )

			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )
			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Moving(false):Best() )

			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self", {stacks=2, bound=">"}):Moving(false):Best() )
			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self", {stacks=2, bound=">"}):Moving(false):Best() )

			list:Cast( "Полная луна", g.target:CanUse("Полная луна"):Moving(false):Best() )
			list:Cast( "Новолуние", g.target:CanUse("Новолуние"):Moving(false):Best() )
			list:Cast( "Полумесяц", g.target:CanUse("Полумесяц"):Moving(false):Best() )

			list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Moving(false):Best() )
			list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Moving(false):Best() )
		end



	end

	return list:Execute()
end


TBRegister(bot)
