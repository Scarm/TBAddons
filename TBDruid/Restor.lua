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
	return self:Moving("false"):CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):TBLastCast("Прикосновение вампира"):MinHP()
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

	if modes.Type == "Off" then 
		return 
	end
	
	--[[
	if modes.Type == "Medium" then 
		list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3):MinHP() ) 
	end	
	
	if modes.Type == "Hiht" then 
		list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3):MinHP() ) 
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() ) 
	end	
	--]]
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	--декурсинг	
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	

	
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
	
	if modes.Type == "Medium" then 
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
	--[[
	list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3):MinHP() ) 
	
	if modes.Type == "Low" then 
		
	end	
	
	if modes.Type == "Medium" then 
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):HealingRange(60,80):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() ) 

	end	
	
	if modes.Type == "Hiht" then 
		list:Cast( "Омоложение",   g.focus:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() )
	end
	--]]

	
	--list:Cast( "Гнев", g.targets:CanUse("Гнев"):Best() )
	
	--[[
	-- Изначально, при полной мане кастуем с оверхилом, затем критерии ужесточаются
	list:Cast( "Буйный рост", g.party:HealingRange(85,95):WildGrowth(5) )
	list:Cast( "Буйный рост", g.party:HealingRange(80,90):WildGrowth(4) )
	list:Cast( "Буйный рост", g.party:HealingRange(75,85):WildGrowth(3) )

	
	-- Кидаем защитку на танка
	list:Cast( "Железная кора", g.focus:HealingRange(50,60):CanUse("Железная кора"):MinHP() )
	list:Cast( "Щит Кенария", g.focus:HealingRange(60,80):CanUse("Щит Кенария"):MinHP() )

	-- экстренный подъем целей
	-- в этом блоке ужесточение требований должно быть минимальным
	local gr = g.party:HealingRange(30,40)
	list:Cast( "Омоложение",                gr:Rejuvenation() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- поднимаем цели, которые надо поднять до фулл хп
	local gr = g.party:NeedFullHeal():UnBlocked()
	list:Cast( "Омоложение",                gr:RangeHP(0,85):Rejuvenation() )
	list:Cast( "Сила Природы",              gr:RangeHP(0,85):ForceOfNature() )
	list:Cast( "Восстановление",            gr:RangeHP(0,85):FreeRegrowth() )
	list:Cast( "Быстрое восстановление",    gr:RangeHP(0,85):Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:RangeHP(0,85):HealingTouch() )
	list:Cast( "Покровительство Природы",   gr:Nourish() )	
	
	-- по танку
	-- обязательно поддерживаем 3 стака
	list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):MinHP() )
	
	-- обновляем гармонию, ниже приоритером стаков, потому что каст бафнет стаки
	list:Cast( "Покровительство Природы", g.focus:Aura("Гармония", "mine", "self", "inverse", 2):Nourish() )
	
	-- если ХП танка не полное - лучше обновить с прохилом
	list:Cast( "Восстановление",          g.focus:HealingRange(50,85):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):FreeRegrowth() )
	list:Cast( "Покровительство Природы", g.focus:HealingRange(60,95):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):Nourish() )	
	
	-- поднимаем просевшего танка
	list:Cast( "Омоложение",                g.focus:HealingRange(80,99):Rejuvenation() )
	local gr = g.focus:HealingRange(50,80)
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- по рейду
	-- поднимаем просевших
	list:Cast( "Омоложение",                g.party:HealingRange(70,85):Rejuvenation() )
	local gr = g.party:HealingRange(50,70)
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- а вот сюда можно попробовать запихнуть простенькую ротацию дд
	
	if (100 * UnitPower("player") / UnitPowerMax("player") > 80) and (g.party:RangeHP(0,90):MinHP())  then
		list:Cast( "Гнев", g.targets:CanUse("Гнев"):MinHP() )
	end
	
--]]	
	return list:Execute()

end
		
		
		
TBRegister(DruidRestor)