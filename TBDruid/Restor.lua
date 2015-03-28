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
			},
			["Class"] = "DRUID",
			["Buffs"] = {
				["Зарождение"] = 155777,
				["Ясность мысли"] = 16870,
				["Гармония"] = 100977,
				["Символ омоложения"] = 96206
			},
			["Buttons"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Run",
					},
					[2] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierGreen.blp",
						ToolTip = "Low",
						GroupId = "Type",
						
					},				
					[3] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
						ToolTip = "High",
						GroupId = "Type",
						default = 1
					},

					[4] = {
						Icon = "Interface\\Icons\\INV_RELICS_IDOLOFREJUVENATION",
						ToolTip = "Hold",
						GroupId = "Tank",
						default = 1
					},
					[5] = {
						Icon = "Interface\\Icons\\INV_MISC_QUESTIONMARK",
						ToolTip = "On",
						GroupId = "Test",
					},
				},
		}
	
function BaseGroup:BestForWG(maxUnits)
	local units = 0
	local realUnits = 0
	local x = 0
	local y = 0
	for key,value in pairs(self) do
		local dx, dy = GetPlayerMapPosition(key)
		if dx > 0 and dy > 0 then
			x = x + dx
			y = y + dy
			realUnits = realUnits + 1
		end
		units = units + 1
	end
	
	if units < maxUnits then
		return
	end
	
	-- вычисляем центр юнитов-игроков (хак для испытаний)
	x = x / realUnits
	y = y / realUnits
	
	local result = nil
	local minDist = 1000000
	for key,value in pairs(self) do
		local dx, dy = GetPlayerMapPosition(key)
		if dx > 0 and dy > 0 then
			local dist = math.sqrt( (x - dx)*(x - dx) + (y - dy)*(y - dy) )
			
			if dist < minDist then
				minDist = dist
				result = value
			end
		end
	end

	return result
end
--[[
function BaseGroup:Rejuvenation()
	return self:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
end



function BaseGroup:ForceOfNature()
	return self:CanUse("Сила Природы"):TBLastCast("Сила Природы"):TBLastCast("Сила Природы"):MinHP()
end

function BaseGroup:Swiftmend()
	return self:CanUse("Быстрое восстановление"):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
end



function BaseGroup:Nourish()
	return self:Moving("false"):CanUse("Покровительство Природы"):MinHP()
end
--]]

function BaseGroup:FreeRegrowth()
	return self:Moving("false"):CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):TBLastCast("Восстановление"):MinHP()
end

function BaseGroup:Regrowth()
	return self:Moving("false"):CanUse("Восстановление"):MinHP()
end

function BaseGroup:HealingTouch()
	return self:Moving("false"):CanUse("Целительное прикосновение"):MinHP()
end

function BaseGroup:WildGrowth(units)
	return self:CanUse("Буйный рост"):BestForWG(units)
end

function DruidRestor:OnUpdate(g, list, modes)

	if IsMounted() then return end

	if modes.Run == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	--декурсинг	
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	
	
	
	if modes.Test == nil then
	
		list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3):MinHP() ) 
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )

		
		if modes.Type == "Low" then 
			list:Cast( "Железная кора", g.focus:RangeHP(0,50):CanUse("Железная кора"):MinHP() )
			list:Cast( "Восстановление", g.focus:RangeHP(0,60):Regrowth() )
		
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 80, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 60, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 60, 30, 100):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
			
			list:Cast( "Восстановление", g.focus:RangeHP(0,70):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.focus:RangeHP(0,70):HealingTouch() )
			
			list:Cast( "Восстановление", g.party:HealingRange(0, 50):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.party:HealingRange(0, 60, 40, 100):HealingTouch() )
			
			list:Cast( "Целительное прикосновение", g.focus:Aura("Гармония", "mine", "self", "inverse", 3):HealingTouch() )
			
			
			list:Cast( "Гнев", g.focus:CanUse("Гнев"):Best() )
		end		
		
		if modes.Type == "High" then 
			list:Cast( "Железная кора", g.focus:RangeHP(0,60):CanUse("Железная кора"):MinHP() )
			list:Cast( "Восстановление", g.focus:RangeHP(0,70):Regrowth() )
			
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 90, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 80, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 80, 30 ,100):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
			
			list:Cast( "Восстановление", g.focus:RangeHP(0,70):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.focus:RangeHP(0,70):HealingTouch() )
			
			list:Cast( "Восстановление", g.party:HealingRange(0,60):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.party:HealingRange(0, 80, 40, 100):HealingTouch() )
			
			list:Cast( "Целительное прикосновение", g.focus:Aura("Гармония", "mine", "self", "inverse", 3):HealingTouch() )
			
			
			list:Cast( "Гнев", g.focus:CanUse("Гнев"):Best() )
		end	
	
	
	else
	
	
		list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3):MinHP() ) 
		list:Cast( "Целительное прикосновение", g.focus:Aura("Гармония", "mine", "self", "inverse", 3):HealingTouch() )
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )
		
		list:Cast( "Омоложение",   g.tanks:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
		list:Cast( "Омоложение",   g.tanks:CanUse("Омоложение"):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )

		
		if modes.Type == "Low" then 
			list:Cast( "Железная кора", g.focus:RangeHP(0,50):CanUse("Железная кора"):MinHP() )
			list:Cast( "Восстановление", g.focus:RangeHP(0,60):Regrowth() )
		
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 80, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 60, 30, 100):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
			list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):HealingRange(0, 60, 30, 100):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
			
			list:Cast( "Восстановление", g.focus:RangeHP(0,70):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.focus:RangeHP(0,70):HealingTouch() )
			
			list:Cast( "Восстановление", g.party:HealingRange(0, 50):FreeRegrowth() )
			list:Cast( "Целительное прикосновение", g.party:HealingRange(0, 60, 40, 100):HealingTouch() )
			
			list:Cast( "Целительное прикосновение", g.focus:Aura("Гармония", "mine", "self", "inverse", 3):HealingTouch() )
			
			
			list:Cast( "Гнев", g.focus:CanUse("Гнев"):Best() )
		end		
		
		if modes.Type == "High" then 
			list:Cast( "Железная кора", g.focus:RangeHP(0,60):CanUse("Железная кора"):MinHP() )
			list:Cast( "Восстановление", g.focus:RangeHP(0,70):Regrowth() )
			
			if g.DamagePerHealer < 0.4 then
				list:Cast( "Быстрое восстановление", g.focus:RangeHP(0,90):CanUse("Быстрое восстановление"):MinHP() )	
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Символ омоложения", "mine", "self", "inverse"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 60):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
				list:Cast( "Восстановление", g.focus:RangeHP(0,85):FreeRegrowth() )

			elseif g.DamagePerHealer < 0.8 then
				list:Cast( "Быстрое восстановление", g.focus:RangeHP(0,90):CanUse("Быстрое восстановление"):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Символ омоложения", "mine", "self", "inverse"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 50):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
				list:Cast( "Восстановление", g.focus:RangeHP(0,85):FreeRegrowth() )
				list:Cast( "Целительное прикосновение", g.party:RangeHP(0, 90):HealingTouch() )
				
			elseif g.DamagePerHealer < 1.2 then
				list:Cast( "Быстрое восстановление", g.focus:RangeHP(0,90):CanUse("Быстрое восстановление"):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Символ омоложения", "mine", "self", "inverse"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 60):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 30):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 30):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
				
				list:Cast( "Восстановление", g.focus:RangeHP(0,85):FreeRegrowth() )
				--list:Cast( "Целительное прикосновение", g.party:RangeHP(0, 90):HealingTouch() )
			
			else 
				list:Cast( "Быстрое восстановление", g.focus:RangeHP(0,90):CanUse("Быстрое восстановление"):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):Aura("Символ омоложения", "mine", "self", "inverse"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 70):Aura("Омоложение", "mine", nil, "inverse", 3):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() ) 
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 40):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
				list:Cast( "Омоложение",   g.party:CanUse("Омоложение"):RangeHP(0, 40):Aura("Зарождение", "mine", nil, "inverse", 3):MinHP() )	
				
				list:Cast( "Восстановление", g.focus:RangeHP(0,85):FreeRegrowth() )
				--list:Cast( "Целительное прикосновение", g.party:RangeHP(0, 90):HealingTouch() )
			end
			
			list:Cast( "Гнев", g.focus:CanUse("Гнев"):Best() )
		end	
	
	end
	
	return list:Execute()

end
		
		
		
TBRegister(DruidRestor)