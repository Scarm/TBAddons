MageFrost = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Стрела ледяного огня"] = 44614,
				["Ледяная стрела"] = 116,
				["Огненный взрыв"] = 2136,
				["Призыв элементаля воды"] = 31687,
				["Ледяная преграда"] = 11426,
				["Антимагия"] = 2139,
			},
			["Buffs"] = {
				["Заморозка мозгов"] = 44549,
				["Ледяные пальцы"] = 112965,
			},
			["Class"] = "MAGE",
			["Buttons"] = {
				[1] = {
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					ToolTip = "Off",
					GroupId = "Run",
				},
				[2] = {
					Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
					ToolTip = "On",
					GroupId = "AoE"
				},
				[3] = {
					Icon = "Interface\\Icons\\SPELL_ICE_LAMENT",
					ToolTip = "On",
					GroupId = "Healing",
					default = 1
				},					
			},
		}
	
function MageFrost:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end
	
	if GetUnitName("playerpet") == nil then
			list:Cast( "Призыв элементаля воды", g.player:CanUse("Призыв элементаля воды"):Best() )
	end
	
	
	
	if GetUnitName("focus") == nil or UnitIsDead("focus") then
		if IsInRaid() or IsInGroup() then
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		else
			list:Focus(g.target:CanAttack():Best())
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		end
	end
	
		list:Cast( "Антимагия", g.targets:CanUse("Антимагия"):CanInterrupt():Best() )
	

	if modes.Healing == "On" then 
		list:Cast( "Ледяная преграда", g.player:CanUse("Ледяная преграда"):Aura("Ледяная преграда", "mine", "self","inverse"):Best() )
	end
	
	if modes.AoE == "On" then
	
	else
		list:Cast( "Стрела ледяного огня", g.focus:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self"):Best() )
		list:Cast( "Огненный взрыв", g.focus:CanUse("Огненный взрыв"):Aura("Ледяные пальцы", "mine", "self"):Best() )	
		list:Cast( "Ледяная стрела", g.focus:CanUse("Ледяная стрела"):Best() )
	end
	return list:Execute()
end
		
		
		
TBRegister(MageFrost)