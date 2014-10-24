WarriorProt= {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Удар грома"] = 6343,
				["Удар громовержца"] = 107570,
				["Победный раж"] = 34428,
				["Зуботычина"] = 6552,
				["Блок щитом"] = 2565,
				["Героический бросок"] = 57755,
				["Ударная волна"] = 46968,
				["Деморализующий крик"] = 1160,
				["Мощный удар щитом"] = 23922,
				["Командирский крик"] = 469,
				["Ярость берсерка"] = 18499,
				["Боевой крик"] = 6673,
				["Непроницаемый щит"] = 112048,
				["Рывок"] = 100,
				["Реванш"] = 6572,
				["Удар героя"] = 78,
				["Рассекающий удар"] = 845,
				["Раскол брони"] = 7386,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Ультиматум"] = 122509,
			},
		}
function BaseGroup:ProtRage(rage)	
	if UnitPower("player") >= rage then
		return self
	end
	return self:CreateDerived()
end
		
function WarriorProt:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end
	
	-- удар-стартер
	--list:Cast( "Рывок", g.target:AutoAttacking("true"):CanUse("Рывок"):Best() )
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	list:Cast( "Зуботычина", g.targets:CanUse("Зуботычина"):CanInterrupt():Best() )

	list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):ProtRage(100):RangeHP(0, 50):Aura("Блок щитом", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Непроницаемый щит", g.player:CanUse("Непроницаемый щит"):ProtRage(100):Aura("Непроницаемый щит", "mine", "self", "inverse"):MinHP() )
	
	if modes.Rotation == "Single" then
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Мощный удар щитом", g.targets:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.targets:CanUse("Реванш"):Best() )
		list:Cast( "Удар громовержца", g.targets:CanUse("Удар громовержца"):Best() )
		list:Cast( "Удар героя", g.targets:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )	
		list:Cast( "Раскол брони", g.targets:CanUse("Раскол брони"):Best() )
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Best() )
	else
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Ударная волна", g.targets:CanUse("Ударная волна"):Best() )	
		list:Cast( "Удар грома", g.targets:CanUse("Удар грома"):Best() )	
		list:Cast( "Мощный удар щитом", g.targets:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.targets:CanUse("Реванш"):Best() )
		list:Cast( "Удар громовержца", g.targets:CanUse("Удар громовержца"):Best() )
		list:Cast( "Удар героя", g.targets:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )	
		list:Cast( "Раскол брони", g.targets:CanUse("Раскол брони"):Best() )
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Best() )
	end
	return list:Execute()
end	
		
TBRegister(WarriorProt)	