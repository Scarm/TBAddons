local bot = {
			["Talents"] = {
				["Клинок гнева"] = 22182,
				["Праведный клинок"] = 22375,
				["Окончательный приговор"] = 22590,
				["Пламя справедливости"] = 22319,
				["Печать Света"] = 22484,
				["Фанатизм"] = 22592,
				["Кавалерист"] = 22483,
				["Гнев небес"] = 22634,
				["Торжество"] = 22186,
				["Божественный молот"] = 22183,
				["Смертный приговор"] = 22557,
				["Освящение"] = 22175,
				["Око за око"] = 22185,
				["Божественный замысел"] = 22591,
				["Слепящий свет"] = 21811,
				["Божественное вмешательство"] = 22485,
				["Великое правосудие"] = 22593,
				["Отмщение вершителя правосудия"] = 22595,
				["Священная война"] = 22215,
				["Покаяние"] = 22180,
				["Кулак правосудия"] = 22179,
			},
			["Name"] = "Воздаяние",
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
          talent = 22186, -- Торжество
          Spell = 210191, -- Торжество
        },
			},
			["Id"] = 3,
			["Spells"] = {
				["Клинок Справедливости"] = 184575,
				["Удар воина Света"] = 35395,
				["Правосудие"] = 20271,
				["Вердикт храмовника"] = 85256,
				["Божественная буря"] = 53385,
				["Торжество"] = 210191,
        ["Клинок гнева"] = 202270,
        ["Божественный молот"] = 198034,
        ["Фанатизм"] = 217020,
        ["Смертный приговор"] = 213757,
        ["Освящение"] = 205228,
        ["Укор"] = 96231,
        ["Испепеляющий след"] = 205273,
			},
			["Buffs"] = {
				["Божественный замысел"] = 223819,
				["Пламя справедливости"] = 209785,
				["Правосудие"] = 197277,
				["Великое сияние верховного мага"] = 177175,
				["Защитник рамкахенов"] = 93337,
			},
			["Class"] = "PALADIN",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	list:Cast( "Укор", g.target:CanUse("Укор"):CanInterrupt():Best() )

  list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )

  list:Cast( "Торжество", g.player:CanUse("Торжество"):Enabled("Торжество"):HolyPower(5):HP("<", 70, "self"):Best() )
  list:Cast( "Торжество", g.player:CanUse("Торжество"):Enabled("Торжество"):Aura("Божественный замысел", "mine", "self", {time=2, bound="<"}):HP("<", 70, "self"):Best() )
  list:Cast( "Торжество", g.player:CanUse("Торжество"):Enabled("Торжество"):Aura("Правосудие", "mine", {time=2, bound="<"}):HP("<", 70, "self"):Best() )

  list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Toggle("AoE"):HolyPower(5):Best() )
  list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Toggle("AoE"):Aura("Божественный замысел", "mine", "self", {time=2, bound="<"}):Best() )
  list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Toggle("AoE"):Aura("Правосудие", "mine", {time=2, bound="<"}):Best() )

  list:Cast( "Смертный приговор", g.target:CanUse("Смертный приговор"):HolyPower(5):Best() )
  list:Cast( "Смертный приговор", g.target:CanUse("Смертный приговор"):Aura("Божественный замысел", "mine", "self", {time=2, bound="<"}):Best() )
  list:Cast( "Смертный приговор", g.target:CanUse("Смертный приговор"):Aura("Правосудие", "mine", {time=2, bound="<"}):Best() )

  list:Cast( "Вердикт храмовника", g.target:CanUse("Вердикт храмовника"):HolyPower(5):Best() )
  list:Cast( "Вердикт храмовника", g.target:CanUse("Вердикт храмовника"):Aura("Божественный замысел", "mine", "self", {time=2, bound="<"}):Best() )
  list:Cast( "Вердикт храмовника", g.target:CanUse("Вердикт храмовника"):Aura("Правосудие", "mine", {time=2, bound="<"}):Best() )

  list:Cast( "Испепеляющий след", g.target:CanUse("Испепеляющий след"):InSpellRange("Вердикт храмовника"):Best() )

  list:Cast( "Фанатизм", g.target:CanUse("Фанатизм"):Charges("Фанатизм", 2, 1.5):Best() )
  list:Cast( "Удар воина Света", g.target:CanUse("Удар воина Света"):Charges("Удар воина Света", 2, 1.5):Best() )

  list:Cast( "Торжество", g.player:CanUse("Торжество"):Enabled("Торжество"):HP("<", 70, "self"):Best() )
  list:Cast( "Смертный приговор", g.target:CanUse("Смертный приговор"):Best() )
  list:Cast( "Вердикт храмовника", g.target:CanUse("Вердикт храмовника"):Best() )

  list:Cast( "Клинок Справедливости", g.target:CanUse("Клинок Справедливости"):Best() )
  list:Cast( "Клинок гнева", g.target:CanUse("Клинок гнева"):Best() )
  list:Cast( "Божественный молот", g.player:CanUse("Божественный молот"):Condition(g.target:InSpellRange("Вердикт храмовника"):Any()):Best() )

  list:Cast( "Фанатизм", g.target:CanUse("Фанатизм"):Best() )
  list:Cast( "Удар воина Света", g.target:CanUse("Удар воина Света"):Best() )

  list:Cast( "Освящение", g.player:CanUse("Освящение"):Condition(g.target:InSpellRange("Вердикт храмовника"):Any()):Best() )

	return list:Execute()
end


TBRegister(bot)
