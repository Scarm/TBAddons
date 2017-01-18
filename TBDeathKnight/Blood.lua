local bot = {
			["Talents"] = {
				["Трепещи!"] = 19226,
				["Призрачное отражение"] = 19220,
				["Надгробный камень"] = 22015,
				["Захват рун"] = 19231,
				["Воля мертвых"] = 19230,
				["Склеп"] = 19221,
				["Антимагический барьер"] = 22135,
				["Кровавое зеркало"] = 21208,
				["Кровавые черви"] = 19165,
				["Разбитое сердце"] = 19166,
				["Кровавая метка"] = 22013,
				["Пожирание душ"] = 19219,
				["Буря костей"] = 21207,
				["Марш проклятых"] = 19228,
				["Чистилище"] = 21209,
				["Нечестивый оплот"] = 19232,
				["Быстрое разложение"] = 19218,
				["Кровопийца"] = 19217,
				["Красная жажда"] = 22014,
				["Жесткая хватка"] = 19227,
				["Кровоотвод"] = 22134,
			},
			["Name"] = "Кровь",
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
					Spell = 205223, -- Увядание
				},
				{
					Type = "spell",
					Spell = 43265, -- Смерть и разложение
				},
				{
					Type = "spell",
					Spell = 49576, -- Хватка смерти
				},
			},
			["Id"] = 1,
			["Spells"] = {
				["Дробление хребта"] = 195182,
				["Смерть и разложение"] = 43265,
				["Кровавая метка"] = 206940,
				["Асфиксия"] = 221562,
				["Антимагический панцирь"] = 48707,
				["Заморозка разума"] = 47528,
				["Вскипание крови"] = 50842,
				["Удар смерти"] = 49998,
				["Удар в сердце"] = 206930,
				["Хватка смерти"] = 49576,
				["Прикосновение смерти"] = 195292,
				["Кровопийца"] = 206931,
				["Кровавое зеркало"] = 206977,
				["Кровь вампира"] = 55233,
				["Темная власть"] = 56222,
				["Увядание"] = 205223,
			},
			["Macro"] = {
				["selfDnD"] = "/cast [@player] Смерть и разложение",
			},
			["Buffs"] = {
				["Смерть и разложение"] = 188290,
				["Кровавая чума"] = 55078,
				["Нечестивая сила"] = 53365,
				["Щит крови"] = 77535,
				["Алая Плеть"] = 81141,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Хватка смерти"] = 51399,
				["Склеп"] = 219788,
				["Защитник рамкахенов"] = 93337,
				["Костяной щит"] = 195181,
			},
			["Class"] = "DEATHKNIGHT",
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

	list:Cast( "Увядание", g.target:CanUse("Увядание",nil,true):Enabled("Увядание"):Best() )

	list:Cast( "Смерть и разложение", g.target:CanUse("Смерть и разложение"):Enabled("Смерть и разложение", "manual"):Best() )
	list:Cast( "selfDnD", g.target:CanUse("Смерть и разложение"):Moving(false):Enabled("Смерть и разложение", "auto"):Best() )
	list:Cast( "selfDnD", g.target:CanUse("Смерть и разложение"):Moving(false):Toggle("AoE"):InSpellRange("Удар смерти"):Best() )

	list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):Energy(">", 100):Best() )
	list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):HP("<", 70, "self"):Best() )

	list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар в сердце"):Aura("Кровавая чума", "mine", "inverse", {time=5, bound=">"}):Best() )
	list:Cast( "Прикосновение смерти", g.target:CanUse("Прикосновение смерти"):Talent("Пожирание душ"):Aura("Кровавая чума", "mine", "inverse", {time=5, bound=">"}):Best() )

	list:Cast( "Дробление хребта", g.target:CanUse("Дробление хребта"):Aura("Костяной щит", "mine","self","inverse", {stacks=8, bound=">"}):Best() )
	list:Cast( "Дробление хребта", g.target:CanUse("Дробление хребта"):Aura("Костяной щит", "mine","self", {time=3, bound="<"}):Best() )
	list:Cast( "Удар в сердце", g.target:CanUse("Удар в сердце"):RunesReady(4, 2):Best() )


	list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар в сердце"):Best() )
	list:Cast( "Хватка смерти", g.target:CanUse("Хватка смерти"):Enabled("Хватка смерти"):InSpellRange("Удар в сердце", 1):Best() )
	list:Cast( "Прикосновение смерти", g.target:CanUse("Прикосновение смерти"):InSpellRange("Удар в сердце", 1):Aura("Кровавая чума", "mine", "inverse", {time=5, bound=">"}):Best() )

	return list:Execute()
end


TBRegister(bot)
