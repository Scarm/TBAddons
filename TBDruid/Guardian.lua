local bot = {
			["Name"] = "Страж",
			["Id"] = 3,
			["Spells"] = {
				["Дикая защита"] = 62606,
				["Неистовое восстановление"] = 22842,
				["Мощное оглушение"] = 5211,
				["Лобовая атака"] = 106839,
				["Щит Кенария"] = 102351,
				["Облик медведя"] = 5487,
				["Растерзать"] = 33745,
				["Рык"] = 6795,
				["Раздавить"] = 80313,
				["Берсерк"] = 50334,
				["Целительное прикосновение"] = 5185,
				["Взбучка"] = 77758,
				["Дубовая кожа"] = 22812,
				["Увечье"] = 33917,
				["Волшебный огонь"] = 770,
				["Инстинкты выживания"] = 61336,
				["Трепка"] = 6807,
			},
			["Class"] = "DRUID",
			["Buffs"] = {
				["Решимость"] = 158300,
				["Зубы и когти_"] = 135286,
				["Дикая защита"] = 132402,
				["Первобытное упорство"] = 155784,
				["Азарт"] = 142073,
				["Зубы и когти"] = 135601,
				["Сон Кенария"] = 145162,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Большая Медведица"] = 159233,
				["Защитник гильдии"] = 97341,
				["Зараженные раны"] = 58180,
				["Раздавить"] = 158792,
				["Сытость"] = 180748,
			},
			["Buttons"] = {
				{
					["ToolTip"] = "Off",
					["Icon"] = "Interface\\Icons\\ABILITY_SEAL",
					["GroupId"] = "Run",
				}, -- [1]
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					["GroupId"] = "AoE",
				}, -- [2]
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["GroupId"] = "Burst",
				}, -- [3]
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\ICONS\\INV_Misc_GroupNeedMore.blp",
					["GroupId"] = "Party",
				}, -- [4]
			},
		}

function bot:OnUpdate(g, list, modes)
	
	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
		
	if GetUnitName("focus") == nil or UnitIsDead("focus") then
		if modes.Party == nil then
			list:Focus(g.target:CanAttack():Best())
		end
	end
	
	local targets = g.targets:Acceptable(g.party)
	
	list:Cast( "Лобовая атака", targets:CanUse("Лобовая атака"):CanInterrupt():Best() )

	list:Cast( "Целительное прикосновение", g.player:CanUse("Целительное прикосновение"):Aura("Сон Кенария", "mine", "self"):HP("<", 70, "self"):Best() )
	list:Cast( "Щит Кенария", g.player:CanUse("Щит Кенария"):HP("<", 70, "self"):Best() )	
	list:Cast( "Неистовое восстановление", g.player:CanUse("Неистовое восстановление"):HP("<", 60, "self"):Best() )	
	
	list:Cast( "Волшебный огонь", targets:CanUse("Волшебный огонь"):InSpellRange("Растерзать","inverse"):ZeroThread():Best() )
	
	if modes.AoE == "On" then
		list:Cast( "Дикая защита", g.player:CanUse("Дикая защита"):Aura("Дикая защита", "mine", "self", "inverse"):MinHP() )
		list:Cast( "Трепка", targets:CanUse("Трепка"):Energy(">", 80):Aura("Зубы и когти", "mine", "self"):Aura("Взбучка", "mine"):Best() )
	else
		list:Cast( "Трепка", targets:CanUse("Трепка"):Energy(">", 60):Aura("Зубы и когти", "mine", "self"):Aura("Взбучка", "mine"):Best() )
		list:Cast( "Дикая защита", g.player:CanUse("Дикая защита"):Aura("Дикая защита", "mine", "self", "inverse"):Energy(">", 90):LastCast("Трепка",false,"total"):MinHP() )
	end
	list:Cast( "Взбучка", targets:CanUse("Взбучка"):InSpellRange("Растерзать"):Aura("Взбучка", "mine", "inverse"):Best() )		
	list:Cast( "Раздавить", targets:CanUse("Раздавить"):Best() )
	list:Cast( "Увечье", targets:CanUse("Увечье"):Best() )	
	list:Cast( "Взбучка", targets:CanUse("Взбучка"):Condition(modes.AoE == "On"):Best() )	
	list:Cast( "Растерзать", targets:CanUse("Растерзать"):Condition(modes.AoE == nil):Best() )					
	list:Cast( "Трепка", targets:CanUse("Трепка"):Energy(">", 80):Aura("Взбучка", "mine"):Best() )
	list:Cast( "Трепка", targets:CanUse("Трепка"):Energy(">", 80):Aura("Растерзать", "mine"):Best() )
	list:Cast( "Волшебный огонь", targets:CanUse("Волшебный огонь"):Best() )
	
	return list:Execute()
end	

		
TBRegister(bot)