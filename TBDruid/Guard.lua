DruidGuard = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Дикая защита"] = 62606,
				["Лобовая атака"] = 106839,
				["Трепка"] = 6807,
				["Щит Кенария"] = 102351,
				["Целительное прикосновение"] = 5185,
				["Взбучка"] = 106832,
				["Дубовая кожа"] = 22812,
				["Растерзать"] = 33745,
				["Волшебный огонь"] = 770,
				["Увечье"] = 33917,
				["Раздавить"] = 80313,
				["Неистовое восстановление"] = 22842,
			},
			["Buffs"] = {
				["Сон Кенария"] = 145162,
				["Зубы и когти"] = 135286,
			},
			["Class"] = "DRUID",
			["Buttons"] = {
				[1] = {
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					ToolTip = "Off",
					GroupId = "Run",
				},
				[2] = {
					Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					ToolTip = "On",
					GroupId = "AoE"
				},
			},
		}
		
function BaseGroup:GuardRage(rage)	
	if UnitPower("player") >= rage then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:InGuardRange()	
	if IsSpellInRange("Растерзать", "target") == 1 then
		return self
	end
	return self:CreateDerived()
end
		
function DruidGuard:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	list:Cast( "Лобовая атака", g.target:CanUse("Лобовая атака"):CanInterrupt():Best() )

	

	list:Cast( "Целительное прикосновение", g.player:CanUse("Целительное прикосновение"):Aura("Сон Кенария", "mine", "self"):HealthLimit(70):Best() )
	list:Cast( "Щит Кенария", g.player:CanUse("Щит Кенария"):HealthLimit(70):Best() )

	
	if modes.AoE == "On" then
		list:Cast( "Неистовое восстановление", g.player:CanUse("Неистовое восстановление"):HealthLimit(60):Best() )	
		list:Cast( "Дикая защита", g.player:CanUse("Дикая защита"):Aura("Дикая защита", "mine", "self", "inverse"):MinHP() )
		list:Cast( "Трепка", g.target:CanUse("Трепка"):GuardRage(80):Aura("Зубы и когти", "mine", "self"):Best() )
		
		list:Cast( "Взбучка", g.target:CanUse("Взбучка"):InGuardRange():Aura("Взбучка", "mine", nil, "inverse"):Best() )		
		list:Cast( "Раздавить", g.target:CanUse("Раздавить"):Best() )		
		list:Cast( "Увечье", g.target:CanUse("Увечье"):Best() )
		list:Cast( "Взбучка", g.target:CanUse("Взбучка"):Best() )
		list:Cast( "Трепка", g.target:CanUse("Трепка"):GuardRage(90):Best() )
		list:Cast( "Волшебный огонь", g.target:CanUse("Волшебный огонь"):Best() )

	else
		list:Cast( "Неистовое восстановление", g.player:CanUse("Неистовое восстановление"):HealthLimit(60):Best() )	
		list:Cast( "Трепка", g.target:CanUse("Трепка"):GuardRage(60):Aura("Зубы и когти", "mine", "self"):Best() )
		list:Cast( "Дикая защита", g.player:CanUse("Дикая защита"):Aura("Дикая защита", "mine", "self", "inverse"):GuardRage(90):TBLastCast("Трепка"):MinHP() )
		
		list:Cast( "Взбучка", g.target:CanUse("Взбучка"):InGuardRange():Aura("Взбучка", "mine", nil, "inverse"):Best() )		
		list:Cast( "Раздавить", g.target:CanUse("Раздавить"):Best() )		
		list:Cast( "Увечье", g.target:CanUse("Увечье"):Best() )
		list:Cast( "Растерзать", g.target:CanUse("Растерзать"):Best() )
		list:Cast( "Трепка", g.target:CanUse("Трепка"):GuardRage(90):Best() )
		list:Cast( "Волшебный огонь", g.target:CanUse("Волшебный огонь"):Best() )
				
	end
	return list:Execute()
end	
		
TBRegister(DruidGuard)	