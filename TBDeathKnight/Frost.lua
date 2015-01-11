DKFrost = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Жнец душ"] = 130736,
				["Заморозка разума"] = 47528,
				["Удар чумы"] = 45462,
				["Удар смерти"] = 49998,
				["Уничтожение"] = 49020,
				["Хватка смерти"] = 49576,
				["Дар смерти"] = 175678,
				["Воющий ветер"] = 49184,
				["Вспышка болезни"] = 77575,
				["Кровоотвод"] = 45529,
				["Лик смерти"] = 47541,
			},
			["Class"] = "DEATHKNIGHT",
			["Buffs"] = {
				["Кровавая чума"] = 55078,
				["Озноб"] = 55095,
				["Машина для убийств"] = 51124,
				["Морозная дымка"] = 59052,
				["Заряд крови"] = 114851,
				["Темная опека"] = 101568,
			},
		}
		
function DKFrost:OnUpdate(g, list, modes)
	
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end


	-- удар-стартер
	--list:Cast( "Хватка смерти", g.target:AutoAttacking("true"):CanUse("Хватка смерти"):Best() )
		
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	list:Cast( "Заморозка разума", g.target:CanUse("Заморозка разума"):CanInterrupt():Best() )
	list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):Aura("Темная опека", "mine", "self"):Best() )
	list:Cast( "Вспышка болезни", g.target:CanUse("Вспышка болезни"):Aura("Озноб", "mine", nil, "inverse", 3):Aura("Кровавая чума", "mine", nil, "inverse", 3):Best() )
	list:Cast( "Удар чумы", g.target:CanUse("Удар чумы"):Aura("Кровавая чума", "mine", nil, "inverse", 3):Best() )
	list:Cast( "Воющий ветер", g.target:CanUse("Воющий ветер"):Aura("Озноб", "mine", nil, "inverse", 3):Best() )
	
	list:Cast( "Воющий ветер", g.target:CanUse("Воющий ветер"):Aura("Морозная дымка", "mine", "self", nil):Best() )
	
	
	if 100 * UnitHealth("player") / UnitHealthMax("player") < 80 then
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):Best() )
	end	
	
	list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Aura("Машина для убийств", "mine", "self", "inverse"):Best() )
	list:Cast( "Уничтожение", g.target:CanUse("Уничтожение"):Best() )
	list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):Aura("Заряд крови", "mine", "self", nil, nil, 5):Best() )
	

	return list:Execute()
end	
		
TBRegister(DKFrost)