MageFrost = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Ледяное копье"] = 30455,
				["Ледяная преграда"] = 11426,
				["Чародейская гениальность"] = 1459,
				["Ледяная стрела"] = 116,
				["Прилив сил"] = 12051,
				["Стрела ледяного огня"] = 44614,
				["Магическая бомба"] = 125430,
				["Призыв элементаля воды"] = 31687,
				["Морозный доспех"] = 7302,
			},
			["Class"] = "MAGE",
			["Buffs"] = {
				["Сила чародея"] = 116257,
				["Заморозка мозгов"] = 44549,
				["Ледяные пальцы"] = 44544
			},
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
		
function MageFrost:OnUpdate()
	if IsMounted() then return end
	
	--[[
	if TBBuff("Ледяная преграда", 1,"player")==nil and TBCanUse("Ледяная преграда","player") then
		return TBCast("Ледяная преграда","player")
	end
	--]]
	
	if TBBuff("Морозный доспех", 1,"player")==nil and TBCanUse("Морозный доспех","player") then
		return TBCast("Морозный доспех","player")
	end
	
	if TBBuff("Чародейская гениальность", 1,"player")==nil and TBCanUse("Чародейская гениальность","player") then
		return TBCast("Чародейская гениальность","player")
	end
	
	if GetUnitName("playerpet") == nil and TBCanUse("Призыв элементаля воды","player") then
		return TBCast("Призыв элементаля воды","player")
	end	

	
	
	if 	TBBuff("Сила чародея",1,"player")==nil and  TBCanUse("Прилив сил","player") then           
		return TBCast("Прилив сил","player")
	end
	
	if TBDebuff("Магическая бомба",1,"target")== nil and  TBCanUse("Магическая бомба","target") then           
		return TBCast("Магическая бомба","target")
	end		
	
	if TBBuff("Заморозка мозгов",1,"player") and  TBCanUse("Стрела ледяного огня","target") then 
		return TBCast("Стрела ледяного огня","target")
	end
	
	if TBBuff("Ледяные пальцы",1,"player") and  TBCanUse("Ледяное копье","target") then 
		return TBCast("Ледяное копье","target")
	end	
	
	if TBCanUse("Ледяная стрела","target") and UnitCanAttack("player", "target") then           
		return TBCast("Ледяная стрела","target")
	end	
end
		
		
		
TBRegister(MageFrost)