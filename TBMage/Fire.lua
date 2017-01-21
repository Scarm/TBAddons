local bot = {
			["Talents"] = {
				["Ба-бах!"] = 22465,
				["Контролируемое горение"] = 22468,
				["Метеор"] = 21633,
				["Вихрь углей"] = 22220,
				["Поджигание"] = 22459,
				["Пироманьяк"] = 22456,
				["Мерцание"] = 22442,
				["Зеркальное изображение"] = 22444,
				["Нестабильная магия"] = 22449,
				["Лихорадочная стремительность"] = 22904,
				["Кольцо мороза"] = 22448,
				["Горящая душа"] = 22905,
				["Живая бомба"] = 22451,
				["Взрывная волна"] = 22908,
				["Колдовской поток"] = 22447,
				["Руна мощи"] = 22445,
				["Огненный след"] = 22472,
				["Поджигатель"] = 22462,
				["Разжигание"] = 21631,
				["Ледяной заслон"] = 22471,
				["Ярость Алекстразы"] = 22450,
			},
			["Name"] = "Огонь",
			["Id"] = 2,
			["Spells"] = {
				["Мерцание"] = 212653,
				["Скачок"] = 1953,
				["Дыхание дракона"] = 31661,
				["Огненная глыба"] = 11366,
				["Ожог"] = 2948,
				["Руна мощи"] = 116011,
				["Огненный взрыв"] = 108853,
				["Огненный шар"] = 133,
				["Вихрь углей"] = 198929,
				["Метеор"] = 153561,
				["Пылающая преграда"] = 235313,
				["Антимагия"] = 2139,
				["Пламя феникса"] = 194466,
				["Огненный столб"] = 2120,
				["Метеор"] = 153561,
				["Живая бомба"] = 44457,
				["Возгорание"] = 190319,
			},
			["Buffs"] = {
				["Руна мощи"] = 116014,
				["Воспламенение"] = 12654,
				["Критический удар"] = 165832,
				["Полоса везения"] = 48108,
				["Знак рока"] = 184073,
				["Разогрев"] = 48107,
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
					Spell = 235313, -- Пылающая преграда
				},
			},
			["Macro"] = {
				["selfFS"] = "/cast [@player] Огненный столб",
				["selfMet"] = "/cast [@player] Метеор",
			},
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

  list:Cast( "Антимагия", g.target:CanUse("Антимагия"):CanInterrupt("first"):Best() )
	list:Cast( "Пылающая преграда", g.player:CanUse("Пылающая преграда"):Enabled("Пылающая преграда"):Aura("Пылающая преграда", "mine", "self", "inverse"):Best() )

	list:Cast( "Руна мощи", g.player:CanUse("Руна мощи"):Aura("Полоса везения", "mine", "self"):Toggle("Burst"):Best() )
	list:Cast( "Возгорание", g.player:CanUse("Возгорание"):Aura("Руна мощи", "mine", "self"):Toggle("Burst"):Best() )


	list:Cast( "selfFS", g.target:CanUse("Огненный столб"):Aura("Полоса везения", "mine", "self"):Toggle("AoE"):Best() )
	list:Cast( "selfMet", g.target:CanUse("Метеор"):Toggle("AoE"):Best() )
	list:Cast( "Дыхание дракона", g.target:CanUse("Дыхание дракона"):Toggle("AoE"):Best() )

	list:Cast( "Огненная глыба", g.target:CanUse("Огненная глыба"):Aura("Полоса везения", "mine", "self"):Best() )
	list:Cast( "Живая бомба", g.target:CanUse("Живая бомба"):Best() )

	list:Cast( "Пламя феникса", g.target:CanUse("Пламя феникса"):Charges("Пламя феникса", 3, 5):Aura("Разогрев", "mine", "self"):LastCast("Пламя феникса", false):LastCast("Огненный взрыв", false):Best() )
	list:Cast( "Огненный взрыв", g.target:CanUse("Огненный взрыв"):Aura("Разогрев", "mine", "self"):LastCast("Пламя феникса", false):LastCast("Огненный взрыв", false):Best() )

	list:Cast( "Пламя феникса", g.target:CanUse("Пламя феникса"):LastCast("Пламя феникса", false):Best() )
	list:Cast( "Огненный шар", g.target:CanUse("Огненный шар"):Best() )

	return list:Execute()
end


TBRegister(bot)
