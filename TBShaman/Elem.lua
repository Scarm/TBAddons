ShamanElem = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Пронизывающий ветер"] = 57994,
				["Щит молний"] = 324,
				["Молния"] = 403,
				["Ледяной шок"] = 8056,
				["Исцеляющий всплеск"] = 8004,
				["Высвободить чары огня"] = 165462,
				["Стихийный удар"] = 73899,
				["Цепная молния"] = 421,
				["Огненный шок"] = 8050,
				["Земной шок"] = 8042,
			},
			["Class"] = "SHAMAN",
			["Buffs"] = {
				["Волна лавы"] = 77762,
			},
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
					Icon = "Interface\\Icons\\SPELL_NATURE_HEALINGWAY",
					ToolTip = "On",
					GroupId = "Healing",
					default = 1
				},					
			},
		}
	
	
function ShamanElem:OnUpdate(g, list, modes)
	
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end

	list:Cast( "Щит молний", g.player:CanUse("Щит молний"):Aura("Щит молний", "mine", "self", "inverse"):Best() )
	list:Cast( "Огненный шок", g.target:CanUse("Огненный шок"):AutoAttacking("true"):Aura("Огненный шок", "mine", nil, "inverse", 6):Best() )
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	list:Cast( "Пронизывающий ветер", g.target:CanUse("Пронизывающий ветер"):CanInterrupt():Best() )

	list:Cast( "Высвободить чары огня", g.player:CanUse("Высвободить чары огня"):Best() )	
	list:Cast( "Стихийный удар", g.target:CanUse("Стихийный удар"):Best() )

	list:Cast( "Земной шок", g.target:CanUse("Земной шок"):Aura("Щит молний", "mine", "self", nil, nil, 15):Best() )
	
	if modes.AoE == "On" then
		list:Cast( "Цепная молния", g.target:CanUse("Цепная молния"):Best() )
	else
		list:Cast( "Молния", g.target:CanUse("Молния"):Best() )
	end
	return list:Execute()
end	
		
TBRegister(ShamanElem)