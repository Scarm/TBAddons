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
	
function DruidRestor:OnUpdate(player, party, focus, targets)
	if IsMounted() or GetShapeshiftForm() == 6 or GetShapeshiftForm() == 4 or GetShapeshiftForm() == 2 then return end
	
	
	local target = player:CanUse("Озарение"):MinHP()
	if target and 100 * UnitPower("player") / UnitPowerMax("player") < 80 then
		return Execute(CastKey("Озарение",target))
	end	
	
	-- экстренный подъем целей

	local target = party:CanUse("Омоложение"):RangeHP(0,40):Aura("Омоложение", "mine", nil, "inverse", 3):MinHP()
	if target then
		return Execute(CastKey("Омоложение",target))
	end
	
	local target = party:CanUse("Сила Природы"):RangeHP(0,40):MinHP()
	if target then
		return Execute(CastKey("Сила Природы",target))
	end	
		
		
	local target = party:CanUse("Быстрое восстановление"):RangeHP(0,40):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
	if target then
		return Execute(CastKey("Быстрое восстановление",target))
	end

	local target = party:CanUse("Восстановление"):Aura("Ясность мысли", "mine", "self", nil, 2):RangeHP(0,40):MinHP()
	if target then
		return Execute(CastKey("Восстановление",target))
	end	
	
	
	-- по танку
	
	-- обязательно поддерживаем 3 стака
	local target = focus:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", nil, 1, 2, 3):MinHP()
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
	


	-- поднимаем просевшего танка
	local target = focus:CanUse("Быстрое восстановление"):RangeHP(0,75):Aura("Омоложение", "mine", nil, nil, 3):MinHP()
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
	
	-- 
	local target = party:CanUse("Буйный рост"):RangeHP(0,85):BestForWG(5)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end	

	local target = party:CanUse("Буйный рост"):RangeHP(0,80):BestForWG(4)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end

	local target = party:CanUse("Буйный рост"):RangeHP(0,75):BestForWG(3)
	if target then
		return Execute(CastKey("Буйный рост",target))
	end	
	
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
	

end
		
		
		
TBRegister(DruidRestor)