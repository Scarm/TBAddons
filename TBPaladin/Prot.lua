PaladinProt = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {

			},
			["Class"] = "PALADIN",
			["Buffs"] = {
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
		
function PaladinProt:OnUpdate()
	if IsMounted() then return end
	
	local sealIdx = 1
	local sealName = "Печать правды"
	local spamStrike = "Удар воина Света"
	local energyStrike = "Вердикт храмовника"
	if IndicatorFrame.EnemyCount > 2 then
		sealIdx = 2
		sealName = "Печать праведности"
		spamStrike = "Молот праведника"
		energyStrike = "Божественная буря"
	end
	
	
	if TBCanInterrupt("target") and TBCanUse("Укор","target") then
		return TBCast("Укор","target")
	end
	
	if TBBuff("Благословение королей", 1,"player")==nil and TBCanUse("Благословение королей","player") then
		return TBCast("Благословение королей","player")
	end	
	-- 
	if TBCanUse("Щит мстителя","target") and UnitAffectingCombat("target") then           
		return TBCast("Щит мстителя","target")
	end
	
	if TBBuff("Священный щит",1,"player")==nil and  TBCanUse("Священный щит","player") then 
		return TBCast("Священный щит","player")
	end	
	
	if UnitPower("player", 9) == 5 and TBCanUse("Щит праведника","target") then           
		return TBCast("Щит праведника","target")
	end	

	if TBCanUse("Молот гнева","target") then           
		return TBCast("Молот гнева","target")
	end		

	if TBCanUse("Правосудие","target") then           
		return TBCast("Правосудие","target")
	end
	
	if TBCanUse("Удар воина Света","target") then           
		return TBCast("Удар воина Света","target")
	end
	
	if UnitPower("player", 9) > 2 and TBCanUse("Щит праведника","target") then           
		return TBCast("Щит праведника","target")
	end
	
	if IndicatorFrame.EnemyCount > 0 then
		if TBCanUse("Освящение","target") then           
			return TBCast("Освящение","target")
		end
		if TBCanUse("Гнев небес","target") then           
			return TBCast("Гнев небес","target")
		end	
	end
end
		
		
		
TBRegister(PaladinProt)