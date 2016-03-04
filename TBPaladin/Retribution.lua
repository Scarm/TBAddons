PaladinRetri = {
			["Name"] = "Воздаяние",
			["Buttons"] = {
				{
					["ToolTip"] = "Off",
					["Icon"] = "Interface\\Icons\\ABILITY_SEAL",
					["GroupId"] = "Run",
				}, -- [1]
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					["GroupId"] = "AoE",
				}, -- [2]
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["GroupId"] = "Burst",
				}, -- [3]
			},
			["Id"] = 3,
			["Spells"] = {
				["Вспышка Света"] = 19750,
				["Молот гнева"] = 158392,
				["Удар воина Света"] = 35395,
				["Правосудие"] = 20271,
				["Окончательный приговор"] = 157048,
				["Печать правды"] = 31801,
				["Печать праведности"] = 20154,
				["Экзорцизм"] = 879,
				["Укор"] = 96231,
				["Божественная буря"] = 53385,
				["Гнев карателя"] = 31884,
			},
			["Buffs"] = {
				["Воин богов"] = 144595,
				["Священный гнев"] = 114232,
				["Порицание"] = 31803,
				["Самоотверженный целитель"] = 114250,
			},
			["Class"] = "PALADIN",
		}
	
function PaladinRetri:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end
	
	list:Cast( "Укор", g.target:CanUse("Укор"):CanInterrupt():Best() )
	list:Cast( "Вспышка Света", g.player:CanUse("Вспышка Света"):HP("<", 80, "self"):Aura("Самоотверженный целитель", "mine", "self", {stacks=3}):Best() )
	
	if modes.AoE == "On" then
		if GetShapeshiftForm() ~= 2 then
			list:Cast( "Печать праведности", g.player:CanUse("Печать праведности"):Best() )
		end
		
		list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):HolyPower(5):InSpellRange("Удар воина Света"):Best() )
		list:Cast( "Молот гнева", g.target:CanUse("Молот гнева"):Best() )
		list:Cast( "Экзорцизм", g.target:CanUse("Экзорцизм"):Best() )
		list:Cast( "Молот праведника", g.target:CanUse("Молот праведника"):Best() )
		list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )	
		list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):InSpellRange("Удар воина Света"):Best() )
	else
		if GetShapeshiftForm() ~= 1 then
			list:Cast( "Печать правды", g.player:CanUse("Печать правды"):Best() )
		end
		
		list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self"):InSpellRange("Удар воина Света"):HolyPower(5):Best() )
		list:Cast( "Окончательный приговор", g.target:CanUse("Окончательный приговор"):HolyPower(5):Best() )
		
		list:Cast( "Молот гнева", g.target:CanUse("Молот гнева"):Best() )
		list:Cast( "Экзорцизм", g.target:CanUse("Экзорцизм"):Best() )
		list:Cast( "Удар воина Света", g.target:CanUse("Удар воина Света"):Best() )
		list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )	
		
		list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self"):InSpellRange("Удар воина Света"):Best() )
		list:Cast( "Окончательный приговор", g.target:CanUse("Окончательный приговор"):Best() )
	end
	
	--[[
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

	list:Cast( "Укор", g.target:CanUse("Укор"):CanInterrupt():Best() )
	
	if modes.Rotation == "Single" then
		--list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():HolyPower(5):Best() )
		--list:Cast( energyStrike, g.target:CanUse(energyStrike):HolyPower(5):Best() )
		list:Cast( "Молот гнева", g.target:CanUse("Молот гнева"):Best() )
		list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Aura("Гнев карателя", "mine", "self", nil):Best() )
		--list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):Aura("Гнев карателя", "mine", "self", nil):InPaladinRange():Best() )
		--list:Cast( "Экзорцизм", g.target:CanUse("Экзорцизм"):Best() )	
		--list:Cast( spamStrike, g.target:CanUse(spamStrike):Best() )
		--list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )	
		--list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():Best() )
		--list:Cast( energyStrike, g.target:CanUse(energyStrike):HolyPower(3):Best() )
		else
		list:Cast( "Божественная буря", g.target:CanUse("Божественная буря"):Aura("Воин богов", "mine", "self", nil):InPaladinRange():HolyPower(5):Best() )
		list:Cast( energyStrike, g.target:CanUse(energyStrike):HolyPower(5):InPaladinRange():Best() )
		list:Cast( "Молот гнева", g.target:CanUse("Молот гнева"):Best() )
		list:Cast( "Экзорцизм", g.target:CanUse("Экзорцизм"):Best() )
		list:Cast( spamStrike, g.target:CanUse(spamStrike):Best() )
		list:Cast( "Правосудие", g.target:CanUse("Правосудие"):Best() )	
		list:Cast( energyStrike, g.target:CanUse(energyStrike):InPaladinRange():HolyPower(3):Best() )
	end
	
	--]]
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
