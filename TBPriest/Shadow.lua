PriestShadow = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Иссушение разума"] = 48045,
				["Взрыв разума"] = 8092,
				["Слово силы: Щит"] = 17,
				["Всепожирающая чума"] = 2944,
				["Слово Тьмы: Боль"] = 589,
				["Прикосновение вампира"] = 34914,
				["Слово Тьмы: Смерть"] = 32379,
				["Облик Тьмы"] = 15473,
				["Кара"] = 585,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
			},
		}

		
function PriestShadow:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return list:Execute()
	end
	
	list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )	
	list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума"):Best() )	
	list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть"):Best() )
	list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума"):Best() )
	
	list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
	list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )	
	list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
	
	return list:Execute()
end
		
		
		
TBRegister(PriestShadow)