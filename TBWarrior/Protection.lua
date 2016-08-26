local bot = {
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
			},
			["Id"] = 3,
			["Spells"] = {
				["Сокрушение"] = 20243,
				["Реванш"] = 6572,
				["Верная победа"] = 202168,
				["Зуботычина"] = 6552,
				["Отражение заклинания"] = 23920,
				["Мощный удар щитом"] = 23922,
				["Победный раж"] = 34428,
				["Стойкость к боли"] = 190456,
				["Перехват"] = 198304,
				["Сосредоточенная ярость"] = 204488,
				["Провокация"] = 355,
				["Боевой крик"] = 1719,
				["Деморализующий крик"] = 1160,
				["Блок щитом"] = 2565,
				["Удар грома"] = 6343,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Рывок"] = 105771,
				["Деморализующий крик"] = 125565,
				["В гущу боя"] = 202602,
				["Глубокие раны"] = 115767,
				["Ультиматум"] = 122510,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Победа"] = 32216,
				["Азарт"] = 142073,
				["Предельный шаг"] = 202164,
				["Блок щитом"] = 132404,
				["Вестник войны"] = 7922,
				["Отмщение: сосредоточенная ярость"] = 202573,
				["Месть: стойкость к боли"] = 202574,
			},
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end	
	if modes.toggle.Stop then 
		return
	end
	
	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt():Best() )
	
	if g.player:AffectingCombat(true):MinHP() then	
		list:Cast( "Сосредоточенная ярость", g.player:CanUse("Сосредоточенная ярость"):Aura("Ультиматум", "mine", "self"):Best() )
		list:Cast( "Сосредоточенная ярость", g.player:CanUse("Сосредоточенная ярость"):Aura("Отмщение: сосредоточенная ярость", "mine", "self"):Best() )

		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Condition(g.target:CanUse("Мощный удар щитом"):Any()):Aura("Блок щитом", "mine", "self", "inverse"):Best() )
		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Charges("Блок щитом", 2):Aura("Блок щитом", "mine", "self", "inverse"):Best() )
		list:Cast( "Удар грома", g.target:CanUse("Удар грома"):Toggle("AoE"):InSpellRange("Сокрушение"):Best() )
		
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Energy(">", 80):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Стойкость к боли", "mine", "self", {time=1, bound="<"}):Best() )
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):Aura("Месть: стойкость к боли", "mine", "self", {time=1, bound="<"}):Best() )		
		list:Cast( "Стойкость к боли", g.player:CanUse("Стойкость к боли"):HP("<", 50, "self"):Best() )
		list:Cast( "Деморализующий крик", g.target:CanUse("Деморализующий крик"):InSpellRange("Сокрушение"):HP("<", 50, "self"):Best() )
		
		list:Cast( "Верная победа", g.target:CanUse("Верная победа"):HP("<", 70, "self"):Best() )
		list:Cast( "Победный раж", g.target:CanUse("Победный раж"):HP("<", 70, "self"):Best() )
	end
	
	
	
	list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
	list:Cast( "Реванш", g.player:CanUse("Реванш"):Condition(g.target:InSpellRange("Сокрушение"):Any()):Best() )
	
	list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )

	
	return list:Execute()
end

		
TBRegister(bot)		
		
--[[
local bot = {
			["Name"] = "Защита",
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
					["Icon"] = "Interface\\Icons\\ABILITY_WARRIOR_SHOCKWAVE",
					["GroupId"] = "ShockWave",
				}, -- [4]				
			},
			["Id"] = 3,
			["Spells"] = {
				["Удар грома"] = 6343,
				["Зуботычина"] = 6552,
				["Мощный удар щитом"] = 23922,
				["Вихрь клинков"] = 46924,
				["Ударная волна"] = 46968,
				["Провокация"] = 355,
				["Героический бросок"] = 57755,
				["Рывок"] = 100,
				["Реванш"] = 6572,
				["Деморализующий крик"] = 1160,
				["Безудержное восстановление"] = 55694,
				["Блок щитом"] = 2565,
				["Удар героя"] = 78,
				["Ни шагу назад"] = 12975,
				["Ярость берсерка"] = 18499,
				["Сокрушение"] = 20243,
				["Непроницаемый щит"] = 112048,
				["Боевой крик"] = 6673,
				["Командирский крик"] = 469,
			},
			["Buffs"] = {
				["Оборонительная стойка"] = 71,
				["Деморализующий крик"] = 125565,
				["Блок щитом"] = 132404,
				["Ударная волна"] = 132168,
				["Глубокие раны"] = 115767,
				["Мания крови"] = 159363,
				["Исступление"] = 12880,
				["Щит и меч"] = 50227,
				["Ультиматум"] = 122510,
			},
			["Class"] = "WARRIOR",
		}
		
		
function bot:OnUpdate(g, list, modes)
	
	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
	
	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt():Best() )
	
	if g.target:CanUse("Мощный удар щитом"):Any() then
		list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Aura("Оборонительная стойка", "mine", "self"):Aura("Блок щитом", "mine", "self", "inverse"):MinHP() )
	end
	list:Cast( "Непроницаемый щит", g.player:CanUse("Непроницаемый щит"):Energy(">", 100):Aura("Оборонительная стойка", "mine", "self"):Aura("Непроницаемый щит", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Непроницаемый щит", g.player:CanUse("Непроницаемый щит"):Energy(">", 60):HP("<", 75, "self"):Aura("Оборонительная стойка", "mine", "self"):Aura("Непроницаемый щит", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Непроницаемый щит", g.player:CanUse("Непроницаемый щит"):HP("<", 50, "self"):Aura("Оборонительная стойка", "mine", "self"):Aura("Непроницаемый щит", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Безудержное восстановление", g.player:CanUse("Безудержное восстановление"):HP("<", 50, "self"):Aura("Безудержное восстановление", "mine", "self", "inverse"):MinHP() )
	
	if modes.ShockWave == "On" then
		list:Cast( "Ударная волна", g.player:CanUse("Ударная волна"):Best() )
	end
	
	
	if modes.Burst == "On" then
		list:Cast( "Вихрь клинков", g.player:CanUse("Вихрь клинков"):Best() )	
	end
	
	if modes.AoE == "On" then
		list:Cast( "Удар грома", g.target:InSpellRange("Сокрушение"):CanUse("Удар грома"):LastCast("Рывок",false,"total"):Best() )
		
		list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.target:CanUse("Реванш"):Best() )
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )
		list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )	
	else
		list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.target:CanUse("Реванш"):Best() )
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )
		list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )	
	end
	
	list:Cast( "Героический бросок", g.target:CanUse("Героический бросок"):Best() )
	
		
	return list:Execute()
end	

		
TBRegister(bot)
--]]	