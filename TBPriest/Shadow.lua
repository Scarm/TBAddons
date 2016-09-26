local bot = {
			["Talents"] = {
				["Придание сил"] = 21718,
				["Внутренний голос"] = 22094,
				["Благосклонные духи"] = 22311,
				["Пожинатель душ"] = 22317,
				["Господство над разумом"] = 19755,
				["Прихоти судьбы"] = 22312,
				["Твердый разум"] = 22313,
				["Покорение безумию"] = 21979,
				["Пронзание разума"] = 21978,
				["Лорд Бездны"] = 21751,
				["Сан'лейн"] = 22310,
				["Мания"] = 22325,
				["Наследие Бездны"] = 21637,
				["Темное сокрушение"] = 21719,
				["Мыслебомба"] = 22487,
				["Тело и душа"] = 22316,
				["Слово Тьмы: Бездна"] = 22314,
				["Подчиняющий разум"] = 21720,
				["Темное прозрение"] = 21755,
				["Луч Бездны"] = 21753,
				["Мазохизм"] = 19758,
			},
			["Name"] = "Тьма",
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
					Spell = 34433, -- "Исчадие Тьмы
				},
				{
					Type = "spell",
					talent = 21718, -- Придание сил
					Spell = 10060, -- Придание сил
				},
				{
					Type = "spell",
					Spell = 17, -- Слово силы: Щит
				},
			},
			["Id"] = 3,
			["Spells"] = {
				["Прикосновение вампира"] = 34914,
				["Взрыв разума"] = 8092,
				["Пытка разума"] = 15407,
				["Слово Тьмы: Боль"] = 589,
        ["Извержение Бездны"] = 228260,
        ["Стрела бездны"] = 205448,
        ["Поток Бездны"] = 205065,
        ["Придание сил"] = 10060,
        ["Исчадие Тьмы"] = 34433,
        ["Слово Тьмы: Смерть"] = 32379,
				["Слово силы: Щит"] = 17,
				["Иссушение разума"] = 48045,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
        ["Облик Бездны"] = 194249,
			},
		}


    function bot:OnUpdate(g, list, modes)
    	if IsMounted() then return end
    	if modes.toggle.Stop then
    		return
    	end

    	list:Cast( "Исчадие Тьмы", g.target:CanUse("Исчадие Тьмы"):Enabled("Исчадие Тьмы"):Best() )
			list:Cast( "Придание сил", g.player:CanUse("Придание сил"):Enabled("Придание сил"):Best() )
			list:Cast( "Слово силы: Щит", g.player:CanUse("Слово силы: Щит"):Aura("Слово силы: Щит", "mine", "inverse", "self"):Enabled("Слово силы: Щит"):Best() )

      list:Cast( "Извержение Бездны", g.target:CanUse("Извержение Бездны", true):Energy(">", 85):Best() )
      list:Cast( "Извержение Бездны", g.target:CanUse("Стрела бездны", true):Best() )

      list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", true):Best() )
      list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", true):Best() )
      list:Cast( "Прикосновение вампира", g.target:Moving(false):CanUse("Прикосновение вампира", true):Aura("Прикосновение вампира", "mine", "inverse", {time=4, bound=">"}):LastCast("Прикосновение вампира", false):Best() )
      list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль", true):Aura("Слово Тьмы: Боль", "mine", "inverse"):Best() )
			list:Cast( "Пытка разума", g.target:Toggle("AoE"):CanUse("Пытка разума"):Best() )
		  list:Cast( "Пытка разума", g.target:CanUse("Пытка разума"):Best() )

    	return list:Execute()
    end


    TBRegister(bot)
