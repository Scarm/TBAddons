WarriorFury = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Вихрь"] = 1680,
				["Казнь"] = 5308,
				["Командирский крик"] = 469,
				["Зуботычина"] = 6552,
				["Боевой крик"] = 6673,
				["Удар героя"] = 78,
				["Зверский удар"] = 100130,
				["Яростный выпад"] = 85288,
				["Ярость берсерка"] = 18499,
				["Рывок"] = 100,
				["Победный раж"] = 34428,
			},
			["Class"] = "WARRIOR",
			["Buffs"] = {
				["Яростный выпад!"] = 131116,
				["Прилив крови"] = 46916,
				["Кровавый фарш"] = 85739,
			},
		}
		
function BaseGroup:FuryRage(rage)	
	if UnitPower("player") >= rage then
		return self
	end
	return self:CreateDerived()
end
		
function WarriorFury:OnUpdate(g, list, modes)
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
		
		list:Cast( "Казнь", g.target:CanUse("Казнь"):ArmsRage(60):Best() )
		list:Cast( "Зверский удар", g.target:CanUse("Зверский удар"):ArmsRage(90):Best() )
		list:Cast( "Зверский удар", g.target:CanUse("Зверский удар"):Aura("Прилив крови", "mine", "self"):Best() )
		list:Cast( "Яростный выпад", g.target:CanUse("Яростный выпад"):Best() )
		
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Best() )
	else
		if UnitHealth("player") < 0.8 * UnitHealthMax("player") then
			list:Cast( "Победный раж", g.target:CanUse("Победный раж"):Best() )
		end
		list:Cast( "Казнь", g.target:CanUse("Казнь"):ArmsRage(60):Best() )
		list:Cast( "Зверский удар", g.target:CanUse("Зверский удар"):ArmsRage(90):Best() )
		list:Cast( "Зверский удар", g.target:CanUse("Зверский удар"):Aura("Прилив крови", "mine", "self"):Best() )
		
		list:Cast( "Вихрь", g.target:CanUse("Яростный выпад"):CanUse("Вихрь"):Aura("Кровавый фарш", "mine", "self", "inverse"):Best() )
		list:Cast( "Яростный выпад", g.target:CanUse("Яростный выпад"):Aura("Кровавый фарш", "mine", "self"):Best() )
		
		list:Cast( "Удар героя", g.target:CanUse("Удар героя"):Best() )
	end
	
	return list:Execute()
end	
		
TBRegister(WarriorFury)	