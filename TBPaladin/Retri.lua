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
				["Воин богов"] = 144595,
			},
			["Class"] = "PALADIN",
		}
	


function BaseGroup:InPaladinRange()	
	if IsSpellInRange("Удар воина Света", "target") then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:HolyPower(points)	
	if UnitPower("player", 9) >= points then
		return self
	end
	return self:CreateDerived()
end
		
function PaladinRetri:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return 
	end
	
	local sealIdx = 1
	local sealName = "Печать правды"
	local spamStrike = "Удар воина Света"
	local energyStrike = "Вердикт храмовника"
	if modes.Rotation == "AoE" then
		sealIdx = 2
		sealName = "Печать праведности"
		spamStrike = "Молот праведника"
		energyStrike = "Божественная буря"
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end

	list:Cast( "Укор", g.targets:CanUse("Укор"):CanInterrupt():Best() )
	list:Cast( "Дознание", g.player:CanUse("Дознание"):Aura("Дознание", "mine", "self", "inverse", 3):HolyPower(3):Best() )

	
	if modes.Rotation == "Single" then
		list:Cast( "Божественная буря", g.targets:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():HolyPower(5):Best() )
		list:Cast( energyStrike, g.targets:CanUse(energyStrike):HolyPower(5):Best() )
		list:Cast( "Молот гнева", g.targets:CanUse("Молот гнева"):Best() )
		list:Cast( spamStrike, g.targets:CanUse(spamStrike):Best() )
		list:Cast( "Правосудие", g.targets:CanUse("Правосудие"):Best() )	
		list:Cast( "Божественная буря", g.targets:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():Best() )
		list:Cast( "Экзорцизм", g.targets:CanUse("Экзорцизм"):Best() )	
		list:Cast( energyStrike, g.targets:CanUse(energyStrike):HolyPower(3):Best() )
		else
		list:Cast( "Божественная буря", g.targets:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():HolyPower(5):Best() )
		list:Cast( energyStrike, g.targets:CanUse(energyStrike):HolyPower(5):InPaladinRange():Best() )
		list:Cast( "Молот гнева", g.targets:CanUse("Молот гнева"):Best() )
		list:Cast( "Экзорцизм", g.targets:CanUse("Экзорцизм"):Best() )
		list:Cast( spamStrike, g.targets:CanUse(spamStrike):Best() )
		list:Cast( "Правосудие", g.targets:CanUse("Правосудие"):Best() )	
		list:Cast( energyStrike, g.targets:CanUse(energyStrike):InPaladinRange():HolyPower(3):Best() )
	end
	return list:Execute()
end

--[[	
function PaladinRetri:OnUpdate(g, list, modes)
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
--]]		
		
TBRegister(PaladinRetri)			
