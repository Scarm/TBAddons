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
	list:Cast( "Природный целитель", g.player:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	
	list:Cast( "Природный целитель", g.tanks:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	

	if g.player:AffectingCombat(true):MinHP() or g.tanks:AffectingCombat(true):MinHP() then

		list:Cast( "Жизнецвет",   g.mainTank:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", "inverse", {skip=5}):MinHP() )
		list:Cast( "Железная кора", g.mainTank:HP("<",60):CanUse("Железная кора"):MinHP() )
		list:Cast( "Природная стремительность", g.mainTank:HP("<",60):CanUse("Природная стремительность"):MinHP() )	
		
		list:Cast( "Восстановление", 
					g.mainTank
					:HP("<",85)
					:Moving(false)
					:CanUse("Восстановление")
					:Aura("Ясность мысли", "mine", "self", {left=6})
					:LastCast("Восстановление", false, "total")
					:MinHP() )
		
		if modes.Burst == "On" then	
			list:Cast( "Буйный рост", 
						g.party
						:Moving(false)
						:CanUse("Буйный рост")
						:HP("<",75)
						:BastForAoE(3,30) )
						
			list:Cast( "Буйный рост", 
						g.party
						:Moving(false)
						:CanUse("Буйный рост")
						:HP("<",85)
						:BastForAoE(4,30) )
						

			if modes.Mushroom == "On"then
				list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(3,10) )
			end						
			
			list:Cast( "Быстрое восстановление", 
						g.party
						:HP("<",70)
						:CanUse("Быстрое восстановление")
						:Aura("Зарождение", "mine")
						:LastCast("Восстановление", false)
						:LastCast("Целительное прикосновение", false)
						:MinHP() )
			
			list:Cast( "Быстрое восстановление", 
						g.party
						:HP("<",70)
						:CanUse("Быстрое восстановление")
						:Aura("Омоложение", "mine")
						:LastCast("Восстановление", false)
						:LastCast("Целительное прикосновение", false)
						:MinHP() )
						
			list:Cast( "Восстановление", g.mainTank:HP("<",50):Moving(false):CanUse("Восстановление"):MinHP() )
			list:Cast( "Восстановление", g.player:HP("<",50):Moving(false):CanUse("Восстановление"):MinHP() )
			
			list:Cast( "Омоложение",   g.mainTank:CanUse("Омоложение"):HP("<",90):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
			list:Cast( "Омоложение",   g.mainTank:CanUse("Омоложение"):HP("<",90):Aura("Зарождение", "mine", "inverse", {skip=6}):MinHP() )			
			list:Cast( "Омоложение",   g.tanks:CanUse("Омоложение"):Aura("Зарождение", "mine", "inverse", {skip=6}):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
			list:Cast( "Омоложение",   g.player:CanUse("Омоложение"):HP("<",90):Aura("Зарождение", "mine", "inverse", {skip=6}):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
			
			list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение")
																:Aura("Гармония", "mine", "self", "inverse", {skip=3})
																:Moving(false)
																:LastCast("Целительное прикосновение", false, "total")
																:MinHP() )
			
			list:Cast( "Восстановление", g.mainTank:HP("<",65):Moving(false):CanUse("Восстановление"):LastCast("Восстановление", false, "total"):MinHP() )
			list:Cast( "Восстановление", g.player:HP("<",65):Moving(false):CanUse("Восстановление"):LastCast("Восстановление", false, "total"):MinHP() )
			
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):NeedFullHeal():Aura("Зарождение", "mine", "inverse", {skip=6}):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
			list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",80):CanUse("Восстановление"):MinHP() )
			list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",90):CanUse("Восстановление"):LastCast("Восстановление", false):MinHP() )
			list:Cast( "Целительное прикосновение", g.party:NeedFullHeal():Moving(false):CanUse("Целительное прикосновение"):MinHP() )	
			
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",50)
					:Aura("Омоложение", "mine", "inverse", {skip=3})
					:Aura("Зарождение", "mine","inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Восстановление", g.party:HP("<",50):Moving(false):CanUse("Восстановление"):MinHP() )

			
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",70)
					:Aura("Омоложение", "mine", "inverse", {skip=3})
					:Aura("Зарождение", "mine","inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",50)
					:Aura("Омоложение", "mine", "inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",50)
					:Aura("Зарождение", "mine", "inverse", {skip=3})
					:MinHP())

			list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",70):Moving(false):MinHP() )
			
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",90)
					:Aura("Омоложение", "mine", "inverse", {skip=3})
					:Aura("Зарождение", "mine","inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",80)
					:Aura("Омоложение", "mine", "inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Омоложение", g.party:CanUse("Омоложение")
					:HP("<",80)
					:Aura("Зарождение", "mine", "inverse", {skip=3})
					:MinHP())
					
			list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",75):Moving(false):MinHP() )					
			list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",85):Moving(false):LastCast("Восстановление", false):LastCast("Целительное прикосновение", false):MinHP() )
			
		else
			list:Cast( "Буйный рост", 
						g.party
						:Moving(false)
						:CanUse("Буйный рост")
						:HP("<",85)
						:BastForAoE(4,30) )
						
			list:Cast( "Буйный рост", 
						g.party
						:Moving(false)
						:CanUse("Буйный рост")
						:HP("<",70)
						:BastForAoE(3,30) )
		
			if modes.Mushroom == "On" then
				list:Cast( "Дикий гриб", g.party:hasMushroom():HP("<",99):CanUse("Дикий гриб"):BastForAoE(2,10) )
				list:Cast( "Дикий гриб", g.party:hasMushroom():CanUse("Дикий гриб"):BastForAoE(4,10) )
			end

			list:Cast( "Восстановление", 
						g.party
						:HP("<",70)
						:Moving(false)
						:CanUse("Восстановление")
						:Aura("Ясность мысли", "mine", "self", {left=4})
						:LastCast("Восстановление", false, "total")
						:MinHP() )

			list:Cast( "Восстановление", 
					g.mainTank
					:Moving(false)
					:CanUse("Восстановление")
					:Aura("Ясность мысли", "mine", "self", {left=4})
					:LastCast("Восстановление", false, "total")
					:MinHP() )
			
			list:Cast( "Быстрое восстановление", 
						g.party
						:HP("<",70)
						:CanUse("Быстрое восстановление")
						:Aura("Зарождение", "mine")
						:LastCast("Восстановление", false)
						:LastCast("Целительное прикосновение", false)
						:MinHP() )
			
			list:Cast( "Быстрое восстановление", 
						g.party
						:HP("<",70)
						:CanUse("Быстрое восстановление")
						:Aura("Омоложение", "mine")
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
																:Aura("Гармония", "mine", "self", "inverse", {skip=3})
																:Moving(false)
																:LastCast("Целительное прикосновение", false, "total")
																:MinHP() )
				
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):NeedFullHeal():Aura("Зарождение", "mine", "inverse", {skip=6}):Aura("Омоложение", "mine", "inverse", {skip=6}):MinHP() )
			list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",80):CanUse("Восстановление"):MinHP() )
			list:Cast( "Восстановление", g.party:NeedFullHeal():Moving(false):HP("<",90):CanUse("Восстановление"):LastCast("Восстановление", false):MinHP() )
			list:Cast( "Целительное прикосновение", g.party:NeedFullHeal():Moving(false):CanUse("Целительное прикосновение"):MinHP() )	
				
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
			
			list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",60):Moving(false):MinHP() )
		end
		list:Cast( "Гнев", g.mainTank:CanUse("Гнев"):Best() )
	end	
		
	return list:Execute()

end
		
		
		
TBRegister(DruidRestor)