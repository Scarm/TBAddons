PaladinHoly = {
			["Name"] = "Свет",
			["Id"] = 1,
			["Spells"] = {
				["Вспышка Света"] = 19750,
				["Торжество"] = 85673,
				["Молот правосудия"] = 853,
				["Свет небес"] = 82326,
				["Частица веры"] = 156910,
				["Азарт"] = 142073,
				["Шок небес"] = 20473,
				["Свет зари"] = 85222,
				["Божественная защита"] = 498,
				["Укор"] = 96231,
				["Священный щит"] = 148039,
				["Святое сияние"] = 82327,
				["Божественная призма"] = 114165,
				["Частица Света"] = 53563,
				["Длань жертвенности"] = 147851,
				["Очищение"] = 4987,
			},
			["Class"] = "PALADIN",
			["Buffs"] = {
				["Великое сияние верховного мага"] = 177176,
				["Рассвет"] = 88819,
				["Символ вспышки Света"] = 54957,
				["Прилив Света"] = 54149,
				["Священный щит_"] = 65148,
				["Озаряющее исцеление"] = 86273,
				["Субстанция Жизни"] = 195007,
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
			},
		}

	
function PaladinHoly:OnUpdate(g, list, modes)
	if IsMounted() then return end

	if modes.Run == "Off" then 
		return 
	end
	
	if g.player:AffectingCombat(true):MinHP() or g.tanks:AffectingCombat(true):MinHP() then
	
		if IsInRaid() then
			if modes.Burst == "On" then
				return self:NormalHeal(g, list, modes)
			else
				return self:NormalHeal(g, list, modes)
			end
		else
			return self:PartyHeal(g, list, modes)
		end	
	else
		if modes.preheal == "On" then
			return self:PreHeal(g, list, modes)
		end
	end
		
	
end	

function PaladinHoly:PreHeal(g, list, modes)
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )

	if g.tanks:Aura("Частица Света", "mine"):MinHP() == nil then
		list:Cast( "Частица Света", g.tanks:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
	end
	if g.tanks:Aura("Частица веры", "mine"):MinHP() == nil then
		list:Cast( "Частица веры", g.tanks:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )	
	end
	if g.party:Aura("Частица Света", "mine"):MinHP() == nil then
		list:Cast( "Частица Света", g.player:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
	end
	if g.party:Aura("Частица веры", "mine"):MinHP() == nil then
		list:Cast( "Частица веры", g.player:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )			
	end
	
	list:Cast( "Торжество",   g.party:CanUse("Торжество"):HP("<",85):HolyPower(5):LastCast("Свет зари", false, "total"):LastCast("Торжество", false, "total"):LastCast("Свет небес", false):MinHP() )
	list:Cast( "Шок небес", g.party:HP("<", 95):CanUse("Шок небес"):MinHP() )
	
	list:Cast( "Свет небес", g.party:HP("<", 85):Moving(false):CanUse("Свет небес"):LastCast("Свет небес", false):MinHP() )	
	return list:Execute()
end

function PaladinHoly:PartyHeal(g, list, modes)
	--декурсинг	
	list:Cast( "Очищение", g.player:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )	
	list:Cast( "Очищение", g.tanks:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )	
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )

	if g.party:Aura("Частица Света", "mine"):MinHP() == nil then
		list:Cast( "Частица Света", g.tanks:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
		list:Cast( "Частица Света", g.player:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
	end
	if g.party:Aura("Частица веры", "mine"):MinHP() == nil then
		list:Cast( "Частица веры", g.tanks:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )	
		list:Cast( "Частица веры", g.player:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )			
	end
	
	list:Cast( "Священный щит", g.tanks:CanUse("Священный щит"):Aura("Священный щит", "mine", "inverse"):MinHP() )	
	list:Cast( "Священный щит", g.player:CanUse("Священный щит"):Aura("Священный щит", "mine", "inverse"):MinHP() )	

	list:Cast( "Свет зари",   g.party:CanUse("Свет зари"):Moving(false):HolyPower(3):HP("<",90):LastCast("Свет зари", false, "total"):BastForAoE(4,30))
	list:Cast( "Свет зари",   g.party:CanUse("Свет зари"):Moving(false):HolyPower(3):HP("<",95):LastCast("Свет зари", false, "total"):BastForAoE(5,30))
	list:Cast( "Торжество",   g.tanks:CanUse("Торжество"):Moving(false):HP("<",85):HolyPower(5):LastCast("Свет зари", false, "total"):LastCast("Торжество", false, "total"):LastCast("Свет небес", false):MinHP() )
	list:Cast( "Торжество",   g.party:CanUse("Торжество"):Moving(false):HP("<",85):HolyPower(5):LastCast("Свет зари", false, "total"):LastCast("Торжество", false, "total"):LastCast("Свет небес", false):MinHP() )

	list:Cast( "Шок небес", g.party:HP("<", 95):CanUse("Шок небес"):MinHP() )

	list:Cast( "Божественная призма", g.mainTank:CanAttack():CanUse("Божественная призма"):MinHP() )

	
	list:Cast( "Свет небес", g.tanks:CanUse("Свет небес"):HP("<", 50):Moving(false):Aura("Прилив Света", "mine", "self"):MinHP() )	
	list:Cast( "Свет небес", g.player:CanUse("Свет небес"):HP("<", 50):Moving(false):Aura("Прилив Света", "mine", "self"):MinHP() )	
	list:Cast( "Вспышка Света", g.tanks:CanUse("Вспышка Света"):HP("<", 50):Moving(false):MinHP() )
	list:Cast( "Вспышка Света", g.player:CanUse("Вспышка Света"):HP("<", 50):Moving(false):MinHP() )	

	
	list:Cast( "Вспышка Света", g.party:HP("<", 40):Moving(false):CanUse("Вспышка Света"):MinHP() )	
	list:Cast( "Вспышка Света", g.party:HP("<", 50):Moving(false):CanUse("Вспышка Света"):LastCast("Вспышка Света", false):MinHP() )	
	
	list:Cast( "Свет небес", g.party:HP("<", 75):Moving(false):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:HP("<", 85):Moving(false):CanUse("Свет небес"):LastCast("Свет небес", false):MinHP() )	

	-- В частицу спам стоит меньше регена маны
	list:Cast( "Свет небес", g.party:CanUse("Свет небес"):HP("<", 85):Moving(false):Aura("Частица Света", "mine"):LastCast("Свет небес", false):MinHP() )
	list:Cast( "Свет небес", g.party:CanUse("Свет небес"):HP("<", 85):Moving(false):Aura("Частица веры", "mine"):LastCast("Свет небес", false):MinHP() )
	
	return list:Execute()
end

function PaladinHoly:NormalHeal(g, list, modes)
	--декурсинг	
	list:Cast( "Очищение", g.player:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )	
	list:Cast( "Очищение", g.tanks:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )	
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Disease","Magic","Poison"):MinHP() )

	if g.tanks:Aura("Частица Света", "mine"):MinHP() == nil then
		list:Cast( "Частица Света", g.tanks:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
	end
	if g.tanks:Aura("Частица веры", "mine"):MinHP() == nil then
		list:Cast( "Частица веры", g.tanks:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )	
	end
	if g.party:Aura("Частица Света", "mine"):MinHP() == nil then
		list:Cast( "Частица Света", g.player:CanUse("Частица Света"):Aura("Частица веры", "mine", "inverse"):MinHP() )	
	end
	if g.party:Aura("Частица веры", "mine"):MinHP() == nil then
		list:Cast( "Частица веры", g.player:CanUse("Частица Света"):Aura("Частица Света", "mine", "inverse"):MinHP() )			
	end
	
	list:Cast( "Священный щит", g.tanks:CanUse("Священный щит"):Aura("Священный щит", "mine", "inverse"):MinHP() )	
	list:Cast( "Священный щит", g.player:CanUse("Священный щит"):Aura("Священный щит", "mine", "inverse"):MinHP() )	

	list:Cast( "Свет зари",   g.party:CanUse("Свет зари"):HolyPower(3):HP("<",90):LastCast("Свет зари", false, "total"):BastForAoE(4,30))
	list:Cast( "Свет зари",   g.party:CanUse("Свет зари"):HolyPower(3):HP("<",95):LastCast("Свет зари", false, "total"):BastForAoE(5,30))
	list:Cast( "Торжество",   g.tanks:CanUse("Торжество"):HP("<",85):HolyPower(5):LastCast("Свет зари", false, "total"):LastCast("Торжество", false, "total"):LastCast("Свет небес", false):MinHP() )
	list:Cast( "Торжество",   g.party:CanUse("Торжество"):HP("<",85):HolyPower(5):LastCast("Свет зари", false, "total"):LastCast("Торжество", false, "total"):LastCast("Свет небес", false):MinHP() )

	list:Cast( "Шок небес", g.party:HP("<", 95):CanUse("Шок небес"):MinHP() )

	list:Cast( "Божественная призма", g.mainTank:CanAttack():CanUse("Божественная призма"):MinHP() )

	
	list:Cast( "Свет небес", g.tanks:CanUse("Свет небес"):HP("<", 50):Moving(false):Aura("Прилив Света", "mine", "self"):MinHP() )	
	list:Cast( "Свет небес", g.player:CanUse("Свет небес"):HP("<", 50):Moving(false):Aura("Прилив Света", "mine", "self"):MinHP() )	
	list:Cast( "Вспышка Света", g.tanks:CanUse("Вспышка Света"):HP("<", 50):Moving(false):MinHP() )
	list:Cast( "Вспышка Света", g.player:CanUse("Вспышка Света"):HP("<", 50):Moving(false):MinHP() )	

	list:Cast( "Святое сияние",   g.party:CanUse("Святое сияние"):HP("<",95):Mana(">", 70):LastCast("Святое сияние", false, "total"):BastForAoE(7,10))
	
	--list:Cast( "Вспышка Света", g.party:HP("<", 40):Moving(false):CanUse("Вспышка Света"):MinHP() )	
	--list:Cast( "Вспышка Света", g.party:HP("<", 50):Moving(false):CanUse("Вспышка Света"):LastCast("Вспышка Света", false):MinHP() )	

	list:Cast( "Свет небес", g.party:HP("<", 40):Moving(false):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:HP("<", 50):Moving(false):CanUse("Свет небес"):LastCast("Свет небес", false):MinHP() )	
	
	list:Cast( "Свет небес", g.party:HP("<", 70):Moving(false):Mana(">", 70):CanUse("Свет небес"):MinHP() )	
	list:Cast( "Свет небес", g.party:HP("<", 85):Moving(false):Mana(">", 70):CanUse("Свет небес"):LastCast("Свет небес", false):MinHP() )	

	-- В частицу спам стоит меньше регена маны
	list:Cast( "Свет небес", g.party:CanUse("Свет небес"):HP("<", 85):Moving(false):Aura("Частица Света", "mine"):LastCast("Свет небес", false):MinHP() )
	list:Cast( "Свет небес", g.party:CanUse("Свет небес"):HP("<", 85):Moving(false):Aura("Частица веры", "mine"):LastCast("Свет небес", false):MinHP() )
	
	return list:Execute()
end
		
TBRegister(PaladinHoly)	


--[[

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

]]		
