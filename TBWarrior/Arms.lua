WarriorArms = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Удар грома"] = 6343,
				["Вихрь"] = 1680,
				["Казнь"] = 163201,
				["Кровопускание"] = 772,
				["Зуботычина"] = 6552,
				["Мощный удар"] = 1464,
				["Боевой крик"] = 6673,
				["Удар колосса"] = 167105,
				["Удар героя"] = 78,
				["Рывок"] = 100,
				["Размашистые удары"] = 12328,
				["Победный раж"] = 34428,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
			},
		}
		

function BaseGroup:ArmsRage(rage)	
	if UnitPower("player") >= rage then
		return self
	end
	return self:CreateDerived()
end
		
function WarriorArms:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end


	-- удар-стартер
	list:Cast( "Рывок", g.target:AutoAttacking("true"):CanUse("Рывок"):Best() )
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	
	list:Cast( "Зуботычина", g.target:CanUse("Зуботычина"):CanInterrupt():Best() )
	list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
	
	if modes.Rotation == "Single" then
		
		if UnitHealth("player") < 0.8 * UnitHealthMax("player") then
			list:Cast( "Победный раж", g.target:CanUse("Победный раж"):Best() )
		end
		list:Cast( "Кровопускание", g.target:CanUse("Кровопускание"):Aura("Кровопускание", "mine", nil, "inverse", 3):Best() )	
		list:Cast( "Удар колосса", g.target:CanUse("Удар колосса"):Aura("Удар колосса", "mine", nil, "inverse"):Best() )
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Best() )
		list:Cast( "Казнь", g.target:CanUse("Казнь"):ArmsRage(85):Best() )
		list:Cast( "Казнь", g.target:CanUse("Казнь"):Aura("Удар колосса", "mine", nil, nil):Best() )
		list:Cast( "Вихрь", g.target:CanUse("Вихрь"):ArmsRage(85):Best() )
		list:Cast( "Вихрь", g.target:CanUse("Вихрь"):Aura("Удар колосса", "mine", nil, nil):Best() )
	else
		--[[
		list:Cast( "Удар грома", g.targets:CanUse("Удар грома"):Best() )	
		list:Cast( "Размашистые удары", g.player:CanUse("Размашистые удары"):Aura("Размашистые удары", "mine", "self", "inverse"):Best() )	
		list:Cast( "Удар колосса", g.targets:CanUse("Удар колосса"):Best() )	
		list:Cast( "Смертельный удар", g.targets:CanUse("Смертельный удар"):Best() )	
		list:Cast( "Казнь", g.targets:CanUse("Казнь"):ArmsRage(70):Best() )	
		list:Cast( "Казнь", g.targets:CanUse("Казнь"):Aura("Удар колосса", "mine", nil, nil):Best() )	
		list:Cast( "Превосходство", g.targets:CanUse("Превосходство"):Aura("Вкус крови", "mine", "self", nil , nil, 4):Best() )	
		list:Cast( "Мощный удар", g.targets:CanUse("Мощный удар"):ArmsRage(110):Best() )	
		list:Cast( "Мощный удар", g.targets:CanUse("Мощный удар"):ArmsRage(70):Aura("Удар колосса", "mine", nil, nil):Best() )	
		list:Cast( "Превосходство", g.targets:CanUse("Превосходство"):Best() )
		--]]
	end
	
	return list:Execute()
end	
		
TBRegister(WarriorArms)	