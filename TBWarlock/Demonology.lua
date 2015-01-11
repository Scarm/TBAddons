WarlockDem = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Похищение жизни"] = 689,
				["Ожог души"] = 6353,
				["Порча"] = 172,
				["Рука Гул'дана"] = 105174,
				["Стрела Тьмы"] = 686,
				["Узы Тьмы"] = 109773,
				["Метаморфоза"] = 103958,
			},
			["Class"] = "WARLOCK",
			["Buffs"] = {
				["Пламя Тьмы"] = 47960,
				["Огненные Недра"] = 122351,
				
			},
		}
WarlockDem.FormChanged = GetTime()	
--function TBCanUse(name, target)	
--function TBCast(name,target)
--function TBBuff(name,isMine,target)   
--function TBDebuff(name,isMine,target)
--function TBBuffElapsed(name,isMine,target)
--function TBBuffStack(name,isMine,target)
--function TBDebuffElapsed(name,isMine,target)
--function TBDebuffStack(name,isMine,target)
--function TBCanInterrupt(target)

--UnitPower(Player,15)
		
function WarlockDem:OnUpdate()
	if IsMounted() then return end
	
	
	if UnitIsUnit("target", "playerpet") == nil then
		return "targetpet"
	end
	
	
	if TBBuff("Узы Тьмы", 1,"player")==nil and TBCanUse("Узы Тьмы","player") then
		return TBCast("Узы Тьмы","player")
	end

	local Corruption = select(7, UnitAura("target", "Порча", nil, "HARMFUL|PLAYER"))
	if Corruption then
		Corruption = Corruption - GetTime()
	else
		Corruption = 0
	end
	local Doom = select(7, UnitAura("target", "Рок", nil, "HARMFUL|PLAYER"))
	if Doom then
		Doom = Doom - GetTime()
	else
		Doom = 0
	end	
	
	if TBBuff("Метаморфоза",1,"player") then
		if Doom < 1.5 and  TBCanUse("Порча","target") then           
			return TBCast("Порча","target")
		end	
		
		if TBCanUse("Рука Гул'дана","target") then           
			return TBCast("Рука Гул'дана","target")
		end
		
		--[[
		if Corruption < 1.5 and GetTime() - WarlockDem.FormChanged > 0.5 then
			WarlockDem.FormChanged = GetTime()
			return TBCast("Метаморфоза","player")
		end
		--]]
		
		if TBCanUse("Стрела Тьмы","target") then           
			return TBCast("Стрела Тьмы","target")
		end
	else
		if Corruption < 1.5 and  TBCanUse("Порча","target") then           
			return TBCast("Порча","target")
		end
		
		if TBCanUse("Рука Гул'дана","target") then           
			return TBCast("Рука Гул'дана","target")
		end

		--[[
		if TBCanUse("Стрела Тьмы","target") and Doom < 1.5 and GetTime() - WarlockDem.FormChanged > 0.5 and  TBCanUse("Метаморфоза","player") then
			WarlockDem.FormChanged = GetTime()
			return TBCast("Метаморфоза","player")
		end	
		--]]

		if TBBuff("Огненные Недра",1,"player") and  TBCanUse("Ожог души","target") then 
			return TBCast("Ожог души","target")
		end	

		if TBCanUse("Стрела Тьмы","target") then           
			return TBCast("Стрела Тьмы","target")
		end
	end	
end
		
		
		
TBRegister(WarlockDem)