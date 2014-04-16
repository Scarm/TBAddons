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
	retrun self:CanUse("Омоложение"):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
end

function BaseGroup:FreeRegrowth()
	return self:NotMoving():CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):MinHP()
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
	return self:NotMoving():CanUse("Покровительство Природы"):MinHP()
end

function BaseGroup:HealingTouch()
	return self:NotMoving():CanUse("Целительное прикосновение"):MinHP()
end

function DruidRestor:OnUpdate(player, party, focus, targets, list)
	if IsMounted() or GetShapeshiftForm() == 6 or GetShapeshiftForm() == 4 or GetShapeshiftForm() == 2 then return end
	
	--[[
	if 100 * UnitPower("player") / UnitPowerMax("player") < 80 then
		list:Cast( "Озарение", player:CanUse("Озарение"):MinHP() )
	end
	
	-- Изначально, при полной мане кастуем с оверхилом, затем критерии ужесточаются
	list:Cast( "Буйный рост", party:HealingRange(60,95):WildGrowth(5) )
	list:Cast( "Буйный рост", party:HealingRange(45,95):WildGrowth(4) )
	list:Cast( "Буйный рост", party:HealingRange(30,95):WildGrowth(3) )
	--]]
	
	local target = player:CanUse("Озарение"):MinHP()
	if target and 100 * UnitPower("player") / UnitPowerMax("player") < 80 then
		return Execute(CastKey("Озарение",target))
	end	
	
	-- Изначально, при полной мане кастуем с оверхилом, затем критерии ужесточаются
	
	local target = party:CanUse("Буйный рост"):RangeHP(0,85):BestForWG(5) --HealingRange(60,95)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end	

	local target = party:CanUse("Буйный рост"):RangeHP(0,80):BestForWG(4) --HealingRange(45,95)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end

	local target = party:CanUse("Буйный рост"):RangeHP(0,75):BestForWG(3) --HealingRange(30,95)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end	
	

	
	
	--[[
	-- экстренный подъем целей
	-- в этом блоке ужесточение требований должно быть минимальным
	local gr = party:HealingRange(30,40)
	list:Cast( "Омоложение",                gr:Rejuvenation() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	---]]
	
	-- экстренный подъем целей
	-- в этом блоке ужесточение требований должно быть минимальным
	local target = party:CanUse("Омоложение"):RangeHP(0,40):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP() --HealingRange(30,40)
	if target then
		return Execute(CastKey("Омоложение",target))
	end
	
	local target = party:CanUse("Сила Природы"):RangeHP(0,40):MinHP() --UnBlocked():HealingRange(30,40)
	if target then
		return Execute(CastKey("Сила Природы",target))
	end	
		
		
	local target = party:CanUse("Быстрое восстановление"):RangeHP(0,40):Aura("Омоложение", "mine", nil, nil, 3):MinHP() --HealingRange(30,40)
	if target then
		return Execute(CastKey("Быстрое восстановление",target))
	end

	local target = party:CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):RangeHP(0,40):MinHP() --HealingRange(30,40)
	if target then
		return Execute(CastKey("Восстановление",target))
	end	
	
	
	
	
	--[[
	--декурсинг	
	list:Cast( "Природный целитель", party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )
	--]]
	
	--декурсинг
	local target = party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP()
	if target then
		return Execute(CastKey("Природный целитель",target))
	end	
	
	
	
	--[[
	-- поднимаем цели, которые надо поднять до фулл хп
	local gr = party:NeedFullHeal():UnBlocked()
	list:Cast( "Омоложение",                gr:RangeHP(0,85):Rejuvenation() )
	list:Cast( "Восстановление",            gr:RangeHP(0,85):FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:RangeHP(0,85):ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:RangeHP(0,85):Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:RangeHP(0,85):HealingTouch() )
	list:Cast( "Покровительство Природы",   gr:Nourish() )	
	--]]
	
	-- поднимаем цели, которые надо поднять до фулл хп
	local target = party:CanUse("Омоложение"):NeedFullHeal():Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
	if target then
		return Execute(CastKey("Омоложение",target))
	end
	
	local target = party:CanUse("Сила Природы"):RangeHP(0,80):NeedFullHeal():MinHP()
	if target then
		return Execute(CastKey("Сила Природы",target))
	end	
		
	local target = party:CanUse("Быстрое восстановление"):NeedFullHeal():Aura("Омоложение", "mine", nil, nil, 3):MinHP()
	if target then
		return Execute(CastKey("Быстрое восстановление",target))
	end

	local target = party:CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):NeedFullHeal():MinHP()
	if target then
		return Execute(CastKey("Восстановление",target))
	end		
	
	local target = party:CanUse("Целительное прикосновение"):RangeHP(0,80):NeedFullHeal():MinHP()
	if target then
		return Execute(CastKey("Целительное прикосновение",target))
	end

	local target = party:CanUse("Покровительство Природы"):NeedFullHeal():MinHP()
	if target then
		return Execute(CastKey("Покровительство Природы",target))
	end	
	
	
	
	--[[
	-- по танку
	-- обязательно поддерживаем 3 стака
	list:Cast( "Жизнецвет",   focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3, 3):MinHP() )
	
	-- обновляем гармонию, ниже приоритером стаков, потому что каст бафнет стаки
	list:Cast( "Покровительство Природы", focus:Aura("Гармония", "mine", "self", "inverse", 2):Nourish() )
	
	-- если ХП танка не полное - лучше обновить с прохилом
	list:Cast( "Восстановление",          focus:HealingRange(50,85):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):FreeRegrowth() )
	list:Cast( "Покровительство Природы", focus:HealingRange(60,95):UnBlocked():Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):Nourish() )	
	--]]
	
	
	-- по танку
	
	-- обязательно поддерживаем 3 стака
	local target = focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, "inverse", 3, 3):MinHP()
	if target then
		return Execute(CastKey("Жизнецвет",target))
	end
	
	-- обновляем гармонию, ниже приоритером стаков, потому что каст бафнем стаки
	local target = focus:CanUse("Покровительство Природы"):Aura("Гармония", "mine", "self", "inverse", 2):MinHP()
	if target then
		return Execute(CastKey("Покровительство Природы",target))
	end

	-- только если есть бафф - можно хотать дальше
	local target = focus:CanUse("Омоложение"):RangeHP(0,90):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
	if target then
		return Execute(CastKey("Омоложение",target))
	end
	
	
	-- если ХП танка не полное - лучше обновить с прохилом
	local target = focus:CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):RangeHP(0,75):Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):MinHP()
	if target then
		return Execute(CastKey("Восстановление",target))
	end		
	
	local target = focus:CanUse("Покровительство Природы"):RangeHP(0,90):Aura("Жизнецвет", "mine", nil, "inverse", 5, 3):MinHP()
	if target then
		return Execute(CastKey("Покровительство Природы",target))
	end	
	

	--[[
	-- поднимаем просевшего танка
	local gr = focus:HealingRange(50,80)
	list:Cast( "Омоложение",                gr:Rejuvenation() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	--]]
	-- поднимаем просевшего танка
	local target = focus:CanUse("Быстрое восстановление"):RangeHP(0,70):Aura("Омоложение", "mine", nil, nil, 743):MinHP()
	if target then
		return Execute(CastKey("Быстрое восстановление",target))
	end		
	
	
	local target = focus:CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):RangeHP(0,60):MinHP()
	if target then
		return Execute(CastKey("Восстановление",target))
	end	
	
	-- поднимаем просевшего танка
	local target = focus:CanUse("Целительное прикосновение"):RangeHP(0,60):MinHP()
	if target then
		return Execute(CastKey("Целительное прикосновение",target))
	end	
	

	
	-- по рейду
	
	--[[
	-- поднимаем просевших
	local gr = party:HealingRange(50,80)
	list:Cast( "Омоложение",                gr:Rejuvenation() )
	list:Cast( "Восстановление",            gr:FreeRegrowth() )
	list:Cast( "Сила Природы",              gr:ForceOfNature() )
	list:Cast( "Быстрое восстановление",    gr:Swiftmend() )
	list:Cast( "Целительное прикосновение", gr:HealingTouch() )
	--]]
	
	-- поднимаем просевших
	local target = party:CanUse("Сила Природы"):RangeHP(0,50):MinHP()
	if target then
		return Execute(CastKey("Сила Природы",target))
	end	
	
	local target = party:CanUse("Быстрое восстановление"):RangeHP(0,70):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
	if target then
		return Execute(CastKey("Быстрое восстановление",target))
	end
	
	-- поднимаем, если сильно просевшие
	local target = party:CanUse("Целительное прикосновение"):RangeHP(0,50):MinHP()
	if target then
		return Execute(CastKey("Целительное прикосновение",target))
	end	
	
	-- хотаем
	local target = party:CanUse("Омоложение"):RangeHP(0,70):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
	if target then
		return Execute(CastKey("Омоложение",target))
	end
	
	-- покастовываем по просевшим
	local target = party:CanUse("Сила Природы"):RangeHP(0,70):MinHP()
	if target then
		return Execute(CastKey("Сила Природы",target))
	end	
		
		

	-- Считаем, что выгоды от заглушки нет и выкидываем её
	
	
	-- заглушка для спама
	if 100 * UnitPower("player") / UnitPowerMax("player") > 30 then
		-- спам по рейду, он важнее
		local target = party:CanUse("Покровительство Природы"):RangeHP(0,60):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
		if target then
			return Execute(CastKey("Покровительство Природы",target))
		end	
		-- спам по танку
		local target = focus:CanUse("Покровительство Природы"):RangeHP(0,70):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
		if target then
			return Execute(CastKey("Покровительство Природы",target))
		end
	end
	
	-- а вот сюда можно попробовать запихнуть простенькую ротацию дд
	-- можно проверить, как будет работать талант Dream of Cenarius
	-- принцип работы: до 70% маны - просто спам, в противном случае - только если есть члены групп с неполным хп
	--[[
	if 100 * UnitPower("player") / UnitPowerMax("player") > 70 then
		list:Cast( "Гнев", targets:CanUse("Гнев"):MinHP() )
	else
		if party:RangeHP(0,90).MinHP() then
			list:Cast( "Гнев", targets:CanUse("Гнев"):MinHP() )
		end
	end
	--]]
	
	return list:Execute()

end
		
		
		
TBRegister(DruidRestor)