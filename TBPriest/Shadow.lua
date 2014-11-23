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
				["Пронзание разума"] = 73510,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
				["Наступление Тьмы"] = 87160,
			},
		}

		
function PriestShadow:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return list:Execute()
	end
	list:Cast( "Облик Тьмы", g.player:CanUse("Облик Тьмы"):Aura("Облик Тьмы", "mine", "self", "inverse"):Best() )
	
	if modes.Rotation == "Single" then	
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )	
		list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):Best() )
		list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", "yes"):Best() )
		
		list:Cast( "Пронзание разума", g.target:Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):CanUse("Пронзание разума"):Best() )
		
		list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )	
		list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
	else
		list:Cast( "Иссушение разума", g.target:CanUse("Иссушение разума"):Best() )	
	end
	
	return list:Execute()
end
		
		
		
TBRegister(PriestShadow)