PaladinHoly = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Вспышка Света"] = 19750,
				["Свет небес"] = 82326,
				["Частица веры"] = 156910,
				["Шок небес"] = 20473,
				["Оружие Света"] = 175699,
				["Свет зари"] = 85222,
				["Торжество"] = 85673,
				["Очищение"] = 4987,
				["Частица Света"] = 53563,
			},
			["Buffs"] = {
				["Вечное пламя"] = 156322,
				["Прилив света"] = 54149,
			},
			["Class"] = "PALADIN",
						["Buttons"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Run",
					},
				},
		}

function BaseGroup:HolyPower(points)	
	if UnitPower("player", 9) >= points then
		return self
	end
	return self:CreateDerived()
end
		
function PaladinHoly:OnUpdate(g, list, modes)
if IsMounted() then return end

	if modes.Run == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	--декурсинг	
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )	

	
	list:Cast( "Торжество",   g.party:CanUse("Торжество"):Aura("Частица Света", "mine"):RangeHP(0,80):HolyPower(3):Aura("Вечное пламя", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Торжество",   g.party:CanUse("Торжество"):Aura("Частица веры" , "mine"):RangeHP(0,80):HolyPower(3):Aura("Вечное пламя", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Свет зари",   g.party:CanUse("Свет зари"):HolyPower(5):MinHP() )
	
	list:Cast( "Шок небес", g.party:RangeHP(0,95):CanUse("Шок небес"):MinHP() )

	-- Хил в особо важные персоны в приоритете. Если быстрый свет небес - сперва сливаем его
	list:Cast( "Свет небес", g.party:RangeHP(0,40):Moving("false"):Aura("Частица Света", "mine"):Aura("Прилив света", "mine", "self", nil, 2):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:RangeHP(0,40):Moving("false"):Aura("Частица веры", "mine"):Aura("Прилив света", "mine", "self", nil, 2):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Вспышка Света", g.party:RangeHP(0,40):Moving("false"):Aura("Частица Света", "mine"):CanUse("Вспышка Света"):MinHP() )
	list:Cast( "Вспышка Света", g.party:RangeHP(0,40):Moving("false"):Aura("Частица веры", "mine"):CanUse("Вспышка Света"):MinHP() )

	--отхил рейда
	list:Cast( "Свет небес", g.party:RangeHP(0,60):Moving("false"):Aura("Прилив света", "mine", "self", nil, 2):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Вспышка Света", g.party:RangeHP(0,30):Moving("false"):CanUse("Вспышка Света"):MinHP() )	

	list:Cast( "Свет небес", g.party:RangeHP(0,60):Moving("false"):Aura("Частица Света", "mine"):Aura("Прилив света", "mine", "self", nil, 2):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:RangeHP(0,60):Moving("false"):Aura("Частица веры", "mine"):Aura("Прилив света", "mine", "self", nil, 2):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Вспышка Света", g.party:RangeHP(0,60):Moving("false"):Aura("Частица Света", "mine"):CanUse("Вспышка Света"):MinHP() )
	list:Cast( "Вспышка Света", g.party:RangeHP(0,60):Moving("false"):Aura("Частица веры", "mine"):CanUse("Вспышка Света"):MinHP() )
	
	list:Cast( "Свет небес", g.party:RangeHP(0,80):Moving("false"):Aura("Частица Света", "mine"):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:RangeHP(0,80):Moving("false"):Aura("Частица веры", "mine"):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:RangeHP(0,80):Moving("false"):CanUse("Свет небес"):MinHP() )	
	
	-- В частицу спам стоит меньше регена маны
	list:Cast( "Свет небес", g.party:RangeHP(0,95):Moving("false"):Aura("Частица Света", "mine"):CanUse("Свет небес"):MinHP() )
	list:Cast( "Свет небес", g.party:RangeHP(0,95):Moving("false"):Aura("Частица веры", "mine"):CanUse("Свет небес"):MinHP() )

	
	if modes.Type == "Low" then 

	end		
	
	if modes.Type == "Medium" then 

	end			
	return list:Execute()
end	
		
TBRegister(PaladinHoly)			
