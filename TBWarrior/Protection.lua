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
		