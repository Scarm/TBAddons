WarriorProt= {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Сокрушение"] = 20243,
				["Рывок"] = 100,
				["Казнь"] = 5308,
				["Победный раж"] = 34428,
				["Зуботычина"] = 6552,
				["Боевой крик"] = 6673,
				["Оглушающий удар"] = 175708,
				["Героический бросок"] = 57755,
				["Удар героя"] = 78,
				["Блок щитом"] = 2565,
				["Провокация"] = 355,
				["Реванш"] = 6572,
				["Удар грома"] = 6343,
				["Мощный удар щитом"] = 23922,
				["Непроницаемый щит"] = 112048,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Ультиматум"] = 122510,
			},
		}
function BaseGroup:ProtRage(rage)	
	if UnitPower("player") >= rage then
		return self
	end
	return self:CreateDerived()
end
	
function BaseGroup:InProtRange()	
	if IsSpellInRange("Реванш", "target") then
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

	--list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):ProtRage(100):RangeHP(0, 50):Aura("Блок щитом", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Блок щитом", g.player:CanUse("Блок щитом"):Aura("Блок щитом", "mine", "self", "inverse"):MinHP() )
	list:Cast( "Непроницаемый щит", g.player:CanUse("Непроницаемый щит"):ProtRage(100):Aura("Непроницаемый щит", "mine", "self", "inverse"):MinHP() )
	
	if UnitHealth("player") < 0.8 * UnitHealthMax("player") then
		list:Cast( "Победный раж", g.target:CanUse("Победный раж"):Best() )
	end
	
	if modes.Rotation == "Single" then
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.target:CanUse("Реванш"):Best() )
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )
		list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )
		list:Cast( "Оглушающий удар", g.target:CanUse("Оглушающий удар"):Best() )
		list:Cast( "Героический бросок", g.target:CanUse("Оглушающий удар"):Best() )
	else
		list:Cast( "Боевой крик", g.player:CanUse("Боевой крик"):Aura("Боевой крик", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Удар грома", g.target:InProtRange():CanUse("Удар грома"):Best() )		
		list:Cast( "Мощный удар щитом", g.target:CanUse("Мощный удар щитом"):Best() )
		list:Cast( "Реванш", g.target:CanUse("Реванш"):Best() )
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Aura("Ультиматум", "mine", "self"):Best() )
		list:Cast( "Сокрушение", g.target:CanUse("Сокрушение"):Best() )
		list:Cast( "Оглушающий удар", g.target:CanUse("Оглушающий удар"):Best() )
		list:Cast( "Героический бросок", g.target:CanUse("Оглушающий удар"):Best() )
	end
	return list:Execute()
end	
		
TBRegister(WarriorProt)	