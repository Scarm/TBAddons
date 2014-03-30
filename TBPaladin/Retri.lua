PaladinRetri = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Молот праведника"] = 53595,
				["Молот гнева"] = 24275,
				["Удар воина Света"] = 35395,
				["Правосудие"] = 20271,
				["Укор"] = 96231,
				["Дознание"] = 84963,
				["Благословение королей"] = 20217,
				["Печать правды"] = 31801,
				["Печать праведности"] = 20154,
				["Экзорцизм"] = 879,
				["Божественная буря"] = 53385,
				["Вердикт храмовника"] = 85256,
				["Торжество"] = 85673,
			},
			["Buffs"] = {
			},
			["Class"] = "PALADIN",
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
		
function PaladinRetri:OnUpdate()
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
	
	--[[
	if TBBuff("Благословение королей", 1,"player")==nil and TBCanUse("Благословение королей","player") then
		return TBCast("Благословение королей","player")
	end
		--]]
	-- 
	if UnitPower("player", 9) > 2 and TBBuff("Дознание",1,"player")==nil and  TBCanUse("Дознание","player") then 
		return TBCast("Дознание","player")
	end
	
	if GetShapeshiftForm() ~= sealIdx and TBCanUse(sealName,"player") then
		return TBCast(sealName,"player")
	end
	
	if UnitPower("player", 9) > 2 and TBBuff("Вечное пламя",1,"player")==nil and UnitHealth("player")/UnitHealthMax("player") < 0.7 and  TBCanUse("Торжество","player") then 
		return TBCast("Торжество","player")
	end	
	
	
	
	if UnitPower("player", 9) == 5 and TBCanUse(energyStrike,"target") then           
		return TBCast(energyStrike,"target")
	end	

	if TBBuff("Божественный замысел", 1,"player") and TBCanUse(energyStrike,"target") then           
		return TBCast(energyStrike,"target")
	end	
	
	if TBCanUse("Молот гнева","target") then           
		return TBCast("Молот гнева","target")
	end	
	
	if TBCanUse("Экзорцизм","target") then           
		return TBCast("Экзорцизм","target")
	end	
	
	if TBCanUse("Правосудие","target") then           
		return TBCast("Правосудие","target")
	end
	
	if TBCanUse(spamStrike,"target") then           
		return TBCast(spamStrike,"target")
	end
	
	if UnitPower("player", 9) > 2 and TBCanUse(energyStrike,"target") then           
		return TBCast(energyStrike,"target")
	end
end
		
		
		
TBRegister(PaladinRetri)