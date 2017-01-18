local bot = {
			["Talents"] = {
				["Эпидемия"] = 22027,
				["Вливание Тьмы"] = 22532,
				["Осквернение"] = 22110,
				["Темный судья"] = 22030,
				["Вскрывающиеся нарывы"] = 22025,
				["Нечестивое бешенство"] = 22516,
				["Всеобщее служение"] = 22024,
				["Изрыгатель слизи"] = 22522,
				["Стискивающие тени"] = 22520,
				["Трупный щит"] = 22530,
				["Изнуряющее заражение"] = 22526,
				["Асфиксия"] = 22524,
				["Заразные гнойники"] = 22028,
				["Зачумленное руническое оружие"] = 22029,
				["Каратель"] = 22518,
				["Чароед"] = 22528,
				["Некроз"] = 22534,
				["Задержавшийся призрак"] = 22022,
				["Черная лихорадка"] = 22026,
				["Зараженные когти"] = 22536,
				["Жнец душ"] = 22538,
			},
			["Name"] = "Нечестивость",
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
			["Id"] = 3,
			["Spells"] = {
				["Смерть и разложение"] = 43265,
				["Заморозка разума"] = 47528,
				["Удар смерти"] = 49998,
				["Темное превращение"] = 63560,
				["Вспышка болезни"] = 77575,
				["Воскрешение мертвых"] = 46584,
				["Удар разложения"] = 85948,
				["Лик смерти"] = 47541,
				["Удар Плети"] = 55090,
        ["Хватка смерти"] = 49576,
			},
      ["Macro"] = {
        ["selfDnD"] = "/cast [@player] Смерть и разложение",
      },
			["Class"] = "DEATHKNIGHT",
			["Buffs"] = {
				["Смерть и разложение"] = 188290,
				["Гнойная язва"] = 194310,
				["Проклятая стойкость"] = 202744,
				["Руническая порча"] = 51460,
				["Мощный удар"] = 212332,
				["Защитник рамкахенов"] = 93337,
				["Вспышка болезни"] = 196782,
				["Нечестивая сила"] = 53365,
				["Смертоносная чума"] = 191587,
				["Гроза демонов"] = 201405,
				["Неумолимый рок"] = 81340,
        ["Темная опека"] = 101568,
			},
		}

function BaseGroup:RunesReady(count, dt)
	local ready = 0
	for i= 1,6,1 do
		local start, duration, runeReady = GetRuneCooldown(i)

		if runeReady then
			ready = ready + 1
		else
			local et = start + duration - GetTime()
			if et < dt then
				ready = ready +1
			end
		end
	end

	if ready >= count then
		return self
	end

	return self:CreateDerived()
end

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	list:Cast( "Заморозка разума", g.target:CanUse("Заморозка разума"):CanInterrupt():Best() )

  list:Cast( "Вспышка болезни", g.target:CanUse("Вспышка болезни"):Aura("Смертоносная чума", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):Aura("Темная опека", "mine", "self"):Best() )

  list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Energy(">", 70):Best() )
  list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Aura("Неумолимый рок", "mine", "self"):Best() )
  list:Cast( "Удар разложения", g.target:CanUse("Удар разложения"):Aura("Гнойная язва", "mine","inverse", {stacks=2, bound=">"}):Best() )
  list:Cast( "Удар Плети", g.target:CanUse("Удар Плети"):Aura("Гнойная язва", "mine", {stacks=2, bound=">"}):Best() )

  list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Best() )
	list:Cast( "Хватка смерти", g.target:CanUse("Хватка смерти"):Enabled("Хватка смерти"):InSpellRange("Уничтожение", 1):Best() )

	return list:Execute()
end


TBRegister(bot)
