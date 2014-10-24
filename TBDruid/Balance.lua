DruidBalance = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Звездный поток"] = 78674,
				["Лунный огонь"] = 8921,
				["Звездный огонь"] = 2912,
				["Гнев"] = 5176,
			},
			["Buffs"] = {
				["Лунное могущество"] = 164547,
				["Солнечное могущество"] = 164545,
				["Солнечный огонь"] = 93402,
				["Лунный пик"] = 171743,
				["Солнечный пик"] = 171744,
			},
			["Class"] = "DRUID",
		}
		
		
function DruidBalance:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end
	
	local power = UnitPower("player", SPELL_POWER_ECLIPSE)
	
	if power <= 0 then
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный пик", "mine", "self"):Best() )
		
		if GetEclipseDirection() == "moon" and power < -50 then
			list:Cast( "Звездный поток", g.target:CanUse("Звездный поток"):Aura("Лунное могущество", "mine", "self", "inverse"):Best() )
		end	
		list:Cast( "Звездный огонь", g.target:CanUse("Звездный огонь"):Best() )	
 
    else
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Солнечный огонь", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Солнечный пик", "mine", "self"):Best() )

		if GetEclipseDirection() == "sun" and power > 50 then
			list:Cast( "Звездный поток", g.target:CanUse("Звездный поток"):Aura("Солнечное могущество", "mine", "self", "inverse"):Best() )
		end	
		list:Cast( "Гнев", g.target:CanUse("Гнев"):Best() )	
		
    end	
	return list:Execute()
end
		
		
		
TBRegister(DruidBalance)