PriestShadow = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Внутренний огонь"] = 588,
				["Взрыв разума"] = 8092,
				["Всепожирающая чума"] = 2944,
				["Слово Тьмы: Боль"] = 589,
				["Слово Тьмы: Смерть"] = 32379,
				["Облик Тьмы"] = 15473,
				["Прикосновение вампира"] = 34914,
				["Слово силы: Стойкость"] = 21562,
				["Кара"] = 585,
				["Пронзание разума"] = 73510,
			},
			["Buffs"] = {
			},
			["Class"] = "PRIEST",
		}
	
--function TBCanUse(name, target)	
--function TBCast(name,target)
--function TBBuff(name,isMine,target)   
--function TBDebuff(name,isMine,target)
--function TBBuffElapsed(name,isMine,target)
--function TBBuffStack(name,isMine,target)
--function TBDebuffElapsed(name,isMine,target)
--function TBDebuffStack(name,isMine,target)
--function TBCanInterrupt(target)
		
function PriestShadow:OnUpdate()
	if IsMounted() then return end
	
	if TBBuff("Слово силы: Стойкость", 1,"player")==nil and TBCanUse("Слово силы: Стойкость","player") then
		return TBCast("Слово силы: Стойкость","player")
	end	
	
	if TBBuff("Внутренний огонь", 1,"player")==nil and TBCanUse("Внутренний огонь","player") then
		return TBCast("Внутренний огонь","player")
	end	
	
	if TBBuff("Облик Тьмы", 1,"player")==nil and TBCanUse("Облик Тьмы","player") then
		return TBCast("Облик Тьмы","player")
	end	

	if TBCanUse("Слово Тьмы: Смерть","target") and TBLastCast("Слово Тьмы: Смерть") then           
		return TBCast("Слово Тьмы: Смерть","target")
	end
	
	if TBCanUse("Всепожирающая чума","target") and UnitPower("player", 13) == 3 then           
		return TBCast("Всепожирающая чума","target")
	end
	
	if TBCanUse("Слово Тьмы: Смерть","target") then           
		return TBCast("Слово Тьмы: Смерть","target")
	end
	
	if TBCanUse("Взрыв разума","target") then           
		return TBCast("Взрыв разума","target")
	end
	
	if TBCanUse("Кара","target") and TBDebuff("Всепожирающая чума",1,"target") then           
		return TBCast("Кара","target")
	end	

	if TBDebuff("Слово Тьмы: Боль",1,"target")== nil and  TBCanUse("Слово Тьмы: Боль","target") then           
		return TBCast("Слово Тьмы: Боль","target")
	end	
	
	if (TBDebuff("Прикосновение вампира",1,"target") == nil or TBDebuff("Прикосновение вампира",1,"target") < 2.0)  and TBLastCast("Прикосновение вампира")==nil and  TBCanUse("Прикосновение вампира","target") then           
		return TBCast("Прикосновение вампира","target")
	end	
	
	if TBCanUse("Кара","target") then           
		return TBCast("Кара","target")
	end	
end
		
		
		
TBRegister(PriestShadow)