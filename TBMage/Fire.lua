MageFire = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Ледяная преграда"] = 11426,
				["Возгорание"] = 11129,
				["Пламенный взрыв"] = 108853,
				["Огненная глыба"] = 11366,
				["Ожог"] = 2948,
				["Стрела ледяного огня"] = 44614,
				["Огненный шар"] = 133,
				["Раскаленный доспех"] = 30482,
				["Магическая бомба"] = 125430,
				["Чародейская гениальность"] = 1459,
				["Антимагия"] = 2139,
			},
			["Class"] = "MAGE",
			["Buffs"] = {
				["Разогрев"] = 48107,
				["Огненная глыба!"] = 48108,
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
		
function MageFire:OnUpdate()
	if IsMounted() then return end
	
	if TBCanInterrupt("target") and TBCanUse("Антимагия","target") then
	return TBCast("Антимагия","target")
	end
	
	if TBBuff("Ледяная преграда", 1,"player")==nil and TBCanUse("Ледяная преграда","player") then
		return TBCast("Ледяная преграда","player")
	end	
	
	
	if TBBuff("Раскаленный доспех", 1,"player")==nil and TBCanUse("Раскаленный доспех","player") then
		return TBCast("Раскаленный доспех","player")
	end
	
	if TBBuff("Чародейская гениальность", 1,"player")==nil and TBCanUse("Чародейская гениальность","player") then
		return TBCast("Чародейская гениальность","player")
	end
	
	--[[
	if TBDebuff("Стрела ледяного огня",1,"target")==nil and UnitIsUnit("targettarget", "player")==nil and TBLastCast("Стрела ледяного огня")==nil and TBCanUse("Стрела ледяного огня","target")  then 
		return TBCast("Стрела ледяного огня","target")
	end	
	--]]

	if TBBuff("Огненная глыба!",1,"player") and  TBCanUse("Огненная глыба","target") then 
		return TBCast("Огненная глыба","target")
	end
	

	if TBBuff("Разогрев",1,"player") and  TBCanUse("Пламенный взрыв","target") then           
		return TBCast("Пламенный взрыв","target")
	end
	
	if TBDebuff("Магическая бомба",1,"target")== nil and  TBCanUse("Магическая бомба","target") then           
		return TBCast("Магическая бомба","target")
	end	
	
	if TBCanUse("Огненный шар","target") then           
		return TBCast("Огненный шар","target")
	end
	
	
end
		
		
		
TBRegister(MageFire)