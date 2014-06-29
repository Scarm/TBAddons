WarriorArms = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Рывок"] = 100,
				["Казнь"] = 5308,
				["Победный раж"] = 34428,
				["Зуботычина"] = 6552,
				["Мощный удар"] = 1464,
				["Боевой крик"] = 6673,
				["Удар колосса"] = 86346,
				["Удар героя"] = 78,
				["Размашистые удары"] = 12328,
				["Рассекающий удар"] = 845,
				["Ярость берсерка"] = 18499,
				["Превосходство"] = 7384,
				["Смертельный удар"] = 12294,
				["Удар грома"] = 6343,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Вкус крови"] = 60503,
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
	
	list:Cast( "Зуботычина", g.targets:CanUse("Зуботычина"):CanInterrupt():Best() )
	if modes.Rotation == "Single" then
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Удар колосса", g.targets:CanUse("Удар колосса"):Best() )	
		list:Cast( "Смертельный удар", g.targets:CanUse("Смертельный удар"):Best() )	
		list:Cast( "Казнь", g.targets:CanUse("Казнь"):ArmsRage(70):Best() )	
		list:Cast( "Казнь", g.targets:CanUse("Казнь"):Aura("Удар колосса", "mine", nil, nil):Best() )	
		list:Cast( "Превосходство", g.targets:CanUse("Превосходство"):Aura("Вкус крови", "mine", "self", nil , nil, 4):Best() )	
		list:Cast( "Мощный удар", g.targets:CanUse("Мощный удар"):ArmsRage(70):Best() )	
		list:Cast( "Мощный удар", g.targets:CanUse("Мощный удар"):ArmsRage(40):Aura("Удар колосса", "mine", nil, nil):Best() )	
		list:Cast( "Превосходство", g.targets:CanUse("Превосходство"):Best() )	
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Best() )
	else
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
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
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Best() )	
	end
	return list:Execute()
end	
		
TBRegister(WarriorArms)	