local bot = {
			["Talents"] = {
				["Нестабильный щит"] = 22527,
				["Мерзлотность"] = 22529,
				["Ослепляющая наледь"] = 22523,
				["Алчущее руническое оружие"] = 22517,
				["Сила поганища"] = 22521,
				["Ледяные когти"] = 22017,
				["Ледяная коса"] = 22531,
				["Истребление"] = 22023,
				["Ледяной натиск"] = 22537,
				["Зима близко"] = 22525,
				["Убийственная эффективность"] = 22018,
				["Ледяной покров"] = 22515,
				["Морозная дымка"] = 22019,
				["Предвестие бури"] = 22535,
				["Белый ходок"] = 22031,
				["Зимний горн"] = 22021,
				["Лавина"] = 22519,
				["Дыхание Синдрагосы"] = 22109,
				["Руническое затухание"] = 22533,
				["Разбивающие удары"] = 22016,
				["Волны холода"] = 22020,
			},
			["Name"] = "Лед",
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
			["Id"] = 2,
			["Spells"] = {
				["Ледяные оковы"] = 45524,
				["Ледяной удар"] = 49143,
				["Заморозка разума"] = 47528,
				["Алчущее руническое оружие"] = 207127,
				["Удар смерти"] = 49998,
				["Ледяной столп"] = 51271,
				["Ледяной натиск"] = 194913,
				["Ледяная коса"] = 207230,
				["Воющий ветер"] = 49184,
				["Зимний горн"] = 57330,
				["Уничтожение"] = 49020,
				["Беспощадность зимы"] = 196770,
				["Хватка смерти"] = 49576,
			},
			["Buffs"] = {
				["Ледяной щит"] = 207203,
				["Проклятая стойкость"] = 202744,
				["Защитник рамкахенов"] = 93337,
				["Режущий лед"] = 51714,
				["Озноб"] = 55095,
				["Сила поганища"] = 207165,
				["Иней"] = 59052,
				["Гроза демонов"] = 201405,
				["Машина для убийств"] = 51124,
				["Беспощадность зимы"] = 211793,
				["Темная опека"] = 101568,
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

  list:Cast( "Воющий ветер", g.target:CanUse("Воющий ветер"):Aura("Озноб", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Воющий ветер", g.target:CanUse("Воющий ветер"):Aura("Иней", "mine", "self"):Best() )

  list:Cast( "Уничтожение", g.target:CanUse("Уничтожение"):Aura("Машина для убийств", "mine", "self"):Best() )
  list:Cast( "Уничтожение", g.target:CanUse("Уничтожение"):RunesReady(4, 2):Best() )

	list:Cast( "Хватка смерти", g.target:CanUse("Хватка смерти"):Enabled("Хватка смерти"):InSpellRange("Уничтожение", 1):Best() )

	return list:Execute()
end


TBRegister(bot)
