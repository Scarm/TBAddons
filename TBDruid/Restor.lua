DruidRestor = {
			["Unique"] = {
			},
			["Id"] = 4,
			["Spells"] = {
				["Омоложение"] = 774,
				["Жизнецвет"] = 33763,
				["Покровительство Природы"] = 50464,
				["Буйный рост"] = 48438,
				["Целительное прикосновение"] = 5185,
				["Быстрое восстановление"] = 18562,
				["Сила Природы"] = 106737,
				["Озарение"] = 29166,
				["Восстановление"] = 8936,
				["Природный целитель"] = 88423,
				["Гнев"] = 5176,
			},
			["Buffs"] = {
				["Гармония"] = 100977,
				["Ясность мысли"] = 16870,
			},
			["Class"] = "DRUID",
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

function BaseGroup:Rejuvenation()
	return self:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
end

function BaseGroup:FreeRegrowth()
	return self:Moving("false"):CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):MinHP()
end

function BaseGroup:ForceOfNature()
	return self:CanUse("Сила Природы"):MinHP()
end

function BaseGroup:Swiftmend()
	return self:CanUse("Быстрое восстановление"):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
end

function BaseGroup:WildGrowth(units)
	return self:CanUse("Буйный рост"):BestForWG(units)
end

function BaseGroup:Nourish()
	return self:Moving("false"):CanUse("Покровительство Природы"):MinHP()
end

function BaseGroup:HealingTouch()
	return self:Moving("false"):CanUse("Целительное прикосновение"):MinHP()
end

function DruidRestor:OnUpdate(g, list, modes)
	if IsMounted() or GetShapeshiftForm() == 6 or GetShapeshiftForm() == 4 or GetShapeshiftForm() == 2 then return end

	if modes.AgroType == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	if 100 * UnitPower("player") / UnitPowerMax("player") < 80 then
		list:Cast( "Озарение", g.player:CanUse("Озарение"):MinHP() )
	end
	--декурсинг	
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )	

	-- Изначально, при полной мане кастуем с оверхилом, затем критерии ужесточаются
	list:Cast( "Буйный рост", g.party:HealingRange(80,90):WildGrowth(5) )
	list:Cast( "Буйный рост", g.party:HealingRange(75,85):WildGrowth(4) )
	list:Cast( "Буйный рост", g.party:HealingRange(70,80):WildGrowth(3) )

	-- экстренный подъем целей
	-- в этом блоке ужесточение требований должно быть минимальным
	local gr = g.party:HealingRange(30,40)
	list:Cast( "Омоложение",                gr:Rejuvenation() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- поднимаем цели, которые надо поднять до фулл хп
	local gr = g.party:NeedFullHeal():UnBlocked()
	list:Cast( "Омоложение",                gr:RangeHP(0,85):Rejuvenation() )
	list:Cast( "Восстановление",            gr:RangeHP(0,85):FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:RangeHP(0,85):ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:RangeHP(0,85):Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:RangeHP(0,85):HealingTouch() )
	list:Cast( "Покровительство Природы",   gr:Nourish() )	
	
	-- по танку
	-- обязательно поддерживаем 3 стака
	list:Cast( "Жизнецвет",   g.focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3, 3):MinHP() )
	
	-- обновляем гармонию, ниже приоритером стаков, потому что каст бафнет стаки
	list:Cast( "Покровительство Природы", g.focus:Aura("Гармония", "mine", "self", "inverse", 2):Nourish() )
	
	-- если ХП танка не полное - лучше обновить с прохилом
	list:Cast( "Восстановление",          g.focus:HealingRange(50,85):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):FreeRegrowth() )
	list:Cast( "Покровительство Природы", g.focus:HealingRange(60,95):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):Nourish() )	
	
	-- поднимаем просевшего танка
	list:Cast( "Омоложение",                g.focus:HealingRange(80,99):Rejuvenation() )
	local gr = g.focus:HealingRange(50,80)
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- по рейду
	-- поднимаем просевших
	list:Cast( "Омоложение",                g.party:HealingRange(70,85):Rejuvenation() )
	local gr = g.party:HealingRange(50,70)
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	
	-- а вот сюда можно попробовать запихнуть простенькую ротацию дд
	
	if (100 * UnitPower("player") / UnitPowerMax("player") > 80) and (g.party:RangeHP(0,90):MinHP())  then
		list:Cast( "Гнев", g.targets:CanUse("Гнев"):MinHP() )
	end
	
	
	return list:Execute()

end
		
		
		
TBRegister(DruidRestor)