local bot = {
			["Name"] = "Бой",
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
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["ToolTip"] = "On",
					["GroupId"] = "Burst",
				}, -- [3]
				{
					["Icon"] = "Interface\\Icons\\ABILITY_ROGUE_RECUPERATE",
					["ToolTip"] = "On",
					["GroupId"] = "Heal",
					["default"] = 1
				}, -- [4]	
				
			},
			["Id"] = 2,
			["Spells"] = {
				["Заживление ран"] = 73651,
				["Кровавый вихрь"] = 121411,
				["Нейтрализующий яд"] = 8679,
				["Коварный удар"] = 1752,
				["Пинок"] = 1766,
				["Череда убийств"] = 51690,
				["Выброс адреналина"] = 13750,
				["Мясорубка"] = 5171,
				["Внезапный удар"] = 8676,
				["Пробивающий удар"] = 84617,
				["Похищающий жизнь яд"] = 108211,
				["Теневое отражение"] = 152151,
				["Потрошение"] = 2098,
				["Быстродействующий яд"] = 157584,
				["Незаметность"] = 1784,
				["Отравляющий укол"] = 5938,
				["Метка смерти"] = 137619,
				["Калечащий яд"] = 3408,
				["Исчезновение"] = 1856,
				["Бросок"] = 121733,
				["Подготовка"] = 14185,
				["Шквал клинков"] = 13877,
				["Смертоносный яд"] = 2823,
			},
			["Class"] = "ROGUE",
			["Buffs"] = {
				["Кровавый вихрь"] = 122233,
				["Нейтрализующий яд"] = 8680,
				["Теневое отражение"] = 156745,
				["Исчезновение_buff"] = 11327,
				["Поверхностное понимание"] = 84745,
				["Глубокое понимание"] = 84747,
				["Умеренное понимание"] = 84746,
				["Предчувствие"] = 115189,
			},
		}
	

function bot:OnUpdate(g, list, modes)
	
	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
	
	if GetUnitName("focus") == nil or UnitIsDead("focus") then
		if IsInRaid() or IsInGroup() then
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		else
			list:Focus(g.target:CanAttack():Best())
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		end
	end
	local targets = g.targets:Acceptable(g.party)
	
	
	if GetShapeshiftForm() == 0 then
		list:Cast( "Незаметность", g.player:Moving(true):CanUse("Незаметность"):Best() )
	end
	
	list:Cast( "Смертоносный яд", g.player:CanUse("Быстродействующий яд"):Aura("Быстродействующий яд", "mine", "self", "inverse"):LastCast("Быстродействующий яд",false,"total"):Best() )
	list:Cast( "Похищающий жизнь яд", g.player:CanUse("Похищающий жизнь яд"):Aura("Похищающий жизнь яд", "mine", "self", "inverse"):Aura("Калечащий яд", "mine", "self", "inverse"):LastCast("Похищающий жизнь яд",false,"total"):LastCast("Калечащий яд",false,"total"):Best() )
	list:Cast( "Калечащий яд", g.player:CanUse("Калечащий яд"):Aura("Похищающий жизнь яд", "mine", "self", "inverse"):Aura("Калечащий яд", "mine", "self", "inverse"):LastCast("Похищающий жизнь яд",false,"total"):LastCast("Калечащий яд",false,"total"):Best() )
	
	if modes.Burst == "On" then
		list:Cast( "Череда убийств", targets:CanUse("Череда убийств"):Aura("Глубокое понимание", "mine", "self"):Aura("Выброс адреналина", "mine", "self","inverse"):Energy("<",60):Best() )
		list:Cast( "Выброс адреналина", g.player:CanUse("Выброс адреналина"):Aura("Глубокое понимание", "mine", "self"):Energy("<",30):Best() )		
		list:Cast( "Исчезновение", g.player:CanUse("Исчезновение"):Aura("Глубокое понимание", "mine", "self"):Energy(">",60):Best() )
		list:Cast( "Подготовка", g.player:CanUse("Подготовка"):Aura("Глубокое понимание", "mine", "self"):Aura("Исчезновение_buff", "mine", "self","inverse"):Best() )
	end
	
	list:Cast( "Внезапный удар", targets:CanUse("Внезапный удар"):Best() )
	list:Cast( "Пинок", targets:CanUse("Пинок"):CanInterrupt():Best() )	
	list:Cast( "Метка смерти", targets:CanUse("Метка смерти"):Best() )		
	list:Cast( "Мясорубка", g.player:CanUse("Мясорубка"):Aura("Мясорубка", "mine", "self", "inverse", {skip=4}):Best() )

	if modes.Heal == "On" then
		list:Cast( "Заживление ран", g.player:CanUse("Заживление ран"):HP("<", 90):Aura("Заживление ран", "mine", "self", "inverse"):Best() )
		list:Cast( "Отравляющий укол", g.targets:CanUse("Отравляющий укол"):HP("<", 90,"self"):Aura("Похищающий жизнь яд", "mine", "self"):Best() )
	end
	
	if modes.AoE == "On" then
		list:Cast( "Шквал клинков", g.player:CanUse("Шквал клинков"):Aura("Шквал клинков", "mine", "self", "inverse"):Best() )
		list:Cast( "Кровавый вихрь", targets:CanUse("Кровавый вихрь"):ComboPoints(5):Best() )
	else
		list:Cast( "Шквал клинков", g.player:Aura("Шквал клинков", "mine", "self"):Best() )
		list:Cast( "Потрошение", targets:CanUse("Потрошение"):Aura("Пробивающий удар", "mine"):Aura("Глубокое понимание", "mine", "self"):ComboPoints(5):Best() )	
		list:Cast( "Потрошение", targets:CanUse("Потрошение"):Aura("Пробивающий удар", "mine"):Aura("Предчувствие", "mine", "self", {stacks=5}):Best() )	
	end
	list:Cast( "Коварный удар", targets:CanUse("Коварный удар"):Aura("Пробивающий удар", "mine"):Energy(">",70):Best() )
	list:Cast( "Коварный удар", targets:CanUse("Коварный удар"):Aura("Пробивающий удар", "mine"):Aura("Поверхностное понимание", "mine", "self", {left=5}):Best() )
	list:Cast( "Коварный удар", targets:CanUse("Коварный удар"):Aura("Пробивающий удар", "mine"):Aura("Умеренное понимание", "mine", "self", {left=5}):Best() )
	list:Cast( "Коварный удар", targets:CanUse("Коварный удар"):Aura("Пробивающий удар", "mine"):Aura("Глубокое понимание", "mine", "self"):Best() )

	list:Cast( "Пробивающий удар", targets:CanUse("Пробивающий удар"):Condition( targets:CanUse("Пробивающий удар"):Aura("Пробивающий удар", "mine"):Any() == nil ):Aura("Пробивающий удар", "mine", "inverse"):Best() )
	
	return list:Execute()
end	
		
TBRegister(bot)
	