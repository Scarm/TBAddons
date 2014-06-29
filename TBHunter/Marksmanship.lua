HunterMM ={
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Прицельный выстрел"] = 19434,
				["Верный выстрел"] = 56641,
				["Залп"] = 2643,
				["Укус змеи"] = 1978,
				["Чародейский выстрел"] = 3044,
				["Выстрел химеры"] = 53209,
				["Убийственный выстрел"] = 53351,
			},
			["Buffs"] = {
				["Огонь!"] = 82926,
				["Ураганный обстрел"] = 82921,
			},
			["Class"] = "HUNTER",
		}
		
function BaseGroup:Power(value)

	if UnitPower("player") >= value then
		return self
	end
	
	return self:CreateDerived()
end		
function HunterMM:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end	

	if modes.Rotation == "Single" then
	
	list:Cast( "Укус змеи", g.targets:CanUse("Укус змеи"):Aura("Укус змеи", "mine", nil, "inverse", 3):MinHP() )
	list:Cast( "Выстрел химеры", g.targets:CanUse("Выстрел химеры"):MinHP() )
	list:Cast( "Убийственный выстрел", g.targets:CanUse("Убийственный выстрел"):MinHP() )
	list:Cast( "Прицельный выстрел", g.targets:CanUse("Прицельный выстрел"):Aura("Огонь!", "mine", "self", nil):MinHP() )
	
	list:Cast( "Чародейский выстрел", g.targets:CanUse("Чародейский выстрел"):Power(80):MinHP() )

	list:Cast( "Верный выстрел", g.targets:CanUse("Верный выстрел"):MinHP() )
	
	elseif modes.Rotation == "AoE" then
	
	list:Cast( "Залп", g.targets:CanUse("Залп"):Aura("Ураганный обстрел", "mine", "self", nil):MinHP() )
	list:Cast( "Залп", g.targets:CanUse("Залп"):Power(90):MinHP() )
	list:Cast( "Верный выстрел", g.targets:CanUse("Верный выстрел"):MinHP() )
	end
	
	return list:Execute()
end	
		
TBRegister(HunterMM)