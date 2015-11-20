DruidRestor = {
			["Unique"] = {
			},
			["Id"] = 4,
			["Spells"] = {
				["Железная кора"] = 102342,
				["Омоложение"] = 774,
				["Быстрое восстановление"] = 18562,
				["Природная стремительность"] = 132158,
				["Целительное прикосновение"] = 5185,
				["Щит Кенария"] = 102351,
				["Природный целитель"] = 88423,
				["Жизнецвет"] = 33763,
				["Буйный рост"] = 48438,
				["Гнев"] = 5176,
				["Восстановление"] = 8936,
				["Дикий гриб"] = 145205,
			},
			["Class"] = "DRUID",
			["Buffs"] = {
				["Зарождение"] = 155777,
				["Ясность мысли"] = 16870,
				["Гармония"] = 100977,
				["Символ омоложения"] = 96206,
				
				["Аура презрения"] = 179987
			},
			["Buttons"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Run",
					},
					[2] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
						ToolTip = "On",
						GroupId = "Burst",
					},
					
					[3] = {
						Icon = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
						ToolTip = "On",
						GroupId = "preheal",
					},						
					
					[4] = {
						Icon = "Interface\\Icons\\DRUID_ABILITY_WILDMUSHROOM_A",
						ToolTip = "On",
						GroupId = "Mushroom",
						default = 1
					},					
				},
		}

	
function BaseGroup:hasMushroom(yes)
	local has = false
	
	for i = 1,4,1 do
		local _,nm = GetTotemInfo(i)
		if nm == "Дикий гриб" then
			has = true
		end
	end
	
	if (has and yes) or ( not has and not yes) then
		return self
	end
	return self:CreateDerived()
end

function DruidRestor:OnUpdate(g, list, modes)

	if IsMounted() then return end

	if modes.Run == "Off" then 
		return 
	end
	
	--декурсинг	
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	

	if UnitAffectingCombat("player") then
		list:Cast( "Жизнецвет",   g.mainTank:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", "inverse", {skip=5}):MinHP() )
		list:Cast( "Железная кора", g.mainTank:HP("<",60):CanUse("Железная кора"):MinHP() )
		list:Cast( "Природная стремительность", g.mainTank:HP("<",60):CanUse("Природная стремительность"):MinHP() )	
		
		if modes.Burst == "On" then
			list:Cast( "Буйный рост", g.party:CanUse("Буйный рост"):BastForAoE(5,30) )
		end
		
		list:Cast( "Восстановление", g.mainTank:HP("<",85)
															:Moving(false)
															:CanUse("Восстановление")
															:Aura("Ясность мысли", "mine", "self", {left=3})
															:LastCast("Восстановление", false, "total")
															:MinHP() )

		list:Cast( "Восстановление", g.party:Moving(false)
															:CanUse("Восстановление")
															:Aura("Ясность мысли", "mine", "self", {left=3})
															:LastCast("Восстановление", false, "total")
															:MinHP() )															
		
		list:Cast( "Быстрое восстановление", g.party:HP("<",70)
															:CanUse("Быстрое восстановление")
															:Aura("Омоложение", "mine")
															:Aura("Зарождение", "mine")
															:LastCast("Восстановление", false)
															:LastCast("Целительное прикосновение", false)
															:MinHP() )
															
		list:Cast( "Восстановление", g.mainTank:HP("<",50):Moving(false):CanUse("Восстановление"):MinHP() )
		list:Cast( "Восстановление", g.player:HP("<",50):Moving(false):CanUse("Восстановление"):MinHP() )
		list:Cast( "Восстановление", g.mainTank:HP("<",70):Moving(false):CanUse("Восстановление"):LastCast("Восстановление", false, "total"):MinHP() )
		list:Cast( "Восстановление", g.player:HP("<",70):Moving(false):CanUse("Восстановление"):LastCast("Восстановление", false, "total"):MinHP() )

		
		list:Cast( "Омоложение",   g.mainTank:CanUse("Омоложение"):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
		list:Cast( "Омоложение",   g.mainTank:CanUse("Омоложение"):Aura("Зарождение", "mine", "inverse", {skip=6}):MinHP() )			

		list:Cast( "Омоложение",   g.tanks:CanUse("Омоложение"):Aura("Зарождение", "mine", "inverse", {skip=6}):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )

		list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение")
															:Aura("Гармония", "mine", "self", "inverse", 3)
															:Moving(false)
															:LastCast("Целительное прикосновение", false, "total")
															:MinHP() )
														
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):NeedFullHeal():Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):NeedFullHeal():Aura("Зарождение", "mine", "inverse", {skip=6}):MinHP() )
		list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",50):CanUse("Восстановление"):MinHP() )
		list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",70):CanUse("Восстановление"):LastCast("Восстановление", false):MinHP() )
		list:Cast( "Целительное прикосновение", g.party:NeedFullHeal():Moving(false):CanUse("Целительное прикосновение"):MinHP() )													
	end
	
	if modes.Burst == "On" then
		if modes.Mushroom == "On" then
			list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(5,10) )
		end
		
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение")
				:Aura("Омоложение", "mine", nil, "inverse", 3)
				:Aura("Зарождение", "mine", nil, "inverse", 3)
				:MinHP() )

		list:Cast( "Омоложение",   g.party:CanUse("Омоложение")
				:Aura("Омоложение", "mine", nil, "inverse", 3)
				:MinHP() )
				
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение")
				:Aura("Зарождение", "mine", nil, "inverse", 3)
				:MinHP() )
		
	else
		if modes.Mushroom == "On" and UnitAffectingCombat("player") then
			list:Cast( "Дикий гриб", g.party:hasMushroom():HP("<",99):CanUse("Дикий гриб"):BastForAoE(3,10) )
			list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(5,10) )
		end
			
		list:Cast( "Омоложение", g.party:CanUse("Омоложение")
				:HP("<",85)
				:Aura("Омоложение", "mine", "inverse", {skip=3})
				:Aura("Зарождение", "mine","inverse", {skip=3})
				:MinHP())
				
		list:Cast( "Омоложение", g.party:CanUse("Омоложение")
				:HP("<",75)
				:Aura("Омоложение", "mine", "inverse", {skip=3})
				:MinHP())
				
		list:Cast( "Омоложение", g.party:CanUse("Омоложение")
				:HP("<",75)
				:Aura("Зарождение", "mine", "inverse", {skip=3})
				:MinHP())
	end
	
	list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",50):Moving(false):MinHP() )
	
	if UnitAffectingCombat("player") then
		list:Cast( "Гнев", g.mainTank:CanUse("Гнев"):Best() )
	end
--[[
	
	list:Cast( "Омоложение",   g.tanks:CanUse("Омоложение"):HP("<",95):Aura("Зарождение", "mine", nil, "inverse", 3):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )

	
	if modes.Burst == "On" then
		--list:Cast( "Буйный рост", g.party:CanUse("Буйный рост"):BastForAoE(5,30) )
		
		if modes.Mushroom == "On" then
			list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(5,10) )
		end
		
		--сначала весим по одной хотке на цели с дотами и с неполным ХП
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HasBossDebuff():Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HP("<",90):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 

		--затем захотываем двумя хотами всех, кто с дебаффом
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HasBossDebuff():Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HasBossDebuff():Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
		
		--и в завершение захотываем двумя хотами вообще всех
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
	
		list:Cast( "Восстановление",   g.party:Moving("false"):CanUse("Восстановление"):MinHP() )
		
	else
		if modes.Mushroom == "On" and UnitAffectingCombat("player") then
			list:Cast( "Дикий гриб", g.party:hasMushroom():HP("<",99):CanUse("Дикий гриб"):BastForAoE(3,10) )
			list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(5,10) )
		end
		
		-- Если маны много - хотаем не сильно просевших и с дебаффом
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(90):HasBossDebuff():Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 				
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(90):HP("<",85):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 		

		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(60):HP("<",85):HasBossDebuff():Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 		
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(60):HP("<",70):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 		
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(60):HP("<",50):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):ManaLimit(60):HP("<",50):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	

		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HP("<",70):HasBossDebuff():Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 		
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HP("<",50):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
		
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HP("<",40):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HP("<",40):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
		
		list:Cast( "Целительное прикосновение", g.party:HP("<",50):HealingTouch() )
		
		if UnitAffectingCombat("player") then
			list:Cast( "Гнев", g.focus:CanUse("Гнев"):Best() )
			list:Cast( "Гнев", g.mainTank:CanUse("Гнев"):Best() )
		end
	end
	
--]]	
		return list:Execute()

end
		
		
		
TBRegister(DruidRestor)