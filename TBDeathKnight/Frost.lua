DKFrost = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Уничтожение"] = 49020,
				["Заморозка разума"] = 47528,
				["Кровавый удар"] = 45902,
				["Вспышка болезни"] = 77575,
				["Удар смерти"] = 49998,
				["Вытягивание чумы"] = 123693,
				["Удар чумы"] = 45462,
				["Воющий ветер"] = 49184,
				["Зимний горн"] = 57330,
				["Кровоотвод"] = 45529,
				["Лик смерти"] = 47541,
			},
			["Class"] = "DEATHKNIGHT",
			["Buffs"] = {
				["Кровавая чума"] = 59879,
				["Озноб"] = 59921,
				["Машина для убийств"] = 51128,
				["Морозная дымка"] = 59052,
			},
		}
		
function DKFrost:OnUpdate(player, party, focus, targets, list)
	if IsMounted() then return end
	if not UnitAffectingCombat("player") then
		return
	end

	
	list:Cast( "Удар чумы", targets:CanUse("Удар чумы"):Aura("Кровавая чума", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Воющий ветер", targets:CanUse("Воющий ветер"):Aura("Озноб", "mine", nil, "inverse", 3):MinHP() )
	--list:Cast( "Кровоотвод", player:CanUse("Кровоотвод"):MinHP() )
	
	if 100 * UnitHealth("player") / UnitHealthMax("player") < 50 then
		list:Cast( "Удар смерти", targets:CanUse("Удар смерти"):MinHP() )
	end	
	list:Cast( "Уничтожение", targets:CanUse("Уничтожение"):Aura("Машина для убийств", "mine", "self", nil):MinHP() )
	list:Cast( "Воющий ветер", targets:CanUse("Воющий ветер"):Aura("Морозная дымка", "mine", "self", nil):MinHP() )
	list:Cast( "Кровавый удар", targets:CanUse("Кровавый удар"):MinHP() )
	
	list:Cast( "Зимний горн", player:CanUse("Зимний горн"):MinHP() )
	
	if 100 * UnitHealth("player") / UnitHealthMax("player") < 80 then
		list:Cast( "Удар смерти", targets:CanUse("Удар смерти"):MinHP() )
	end	
	list:Cast( "Уничтожение", targets:CanUse("Уничтожение"):MinHP() )
	
	
	return list:Execute()
end	
		
TBRegister(DKFrost)