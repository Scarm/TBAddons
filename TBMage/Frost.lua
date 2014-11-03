MageFrost = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Стрела ледяного огня"] = 44614,
				["Ледяная стрела"] = 116,
				["Огненный взрыв"] = 2136,
				["Призыв элементаля воды"] = 31687,
			},
			["Buffs"] = {
				["Заморозка мозгов"] = 44549,
				["Ледяные пальцы"] = 112965,
			},
			["Class"] = "MAGE",
		}
	
function MageFrost:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.AgroType == "Off" then 
		return list:Execute()
	end
	
	if GetUnitName("playerpet") == nil then
			list:Cast( "Призыв элементаля воды", g.player:CanUse("Призыв элементаля воды"):Best() )
	end	
	
	list:Cast( "Стрела ледяного огня", g.target:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self"):Best() )
	list:Cast( "Огненный взрыв", g.target:CanUse("Огненный взрыв"):Aura("Ледяные пальцы", "mine", "self"):Best() )	
	list:Cast( "Ледяная стрела", g.target:CanUse("Ледяная стрела"):Best() )

	
	return list:Execute()
end
		
		
		
TBRegister(MageFrost)