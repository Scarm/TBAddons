local bot = {
			["Name"] = "Лед",
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
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["ToolTip"] = "On",
					["GroupId"] = "Burst",
				}, -- [3]
				{
					["Icon"] = "Interface\\Icons\\SPELL_ICE_LAMENT",
					["ToolTip"] = "On",
					["GroupId"] = "Heal",
					["default"] = 1
				}, -- [4]	
				{
					["Icon"] = "Interface\\Icons\\ABILITY_MAGE_FROSTJAW",
					["ToolTip"] = "On",
					["GroupId"] = "FrostLaw",
				}, -- [5]				
			
			},
			["Id"] = 3,
			["Spells"] = {
				["Конус холода"] = 120,
				["Ледяное копье"] = 30455,
				["Антимагия"] = 2139,
				["Ледяная бомба"] = 112948,
				["Берсерк"] = 26297,
				["Ледяной шар"] = 84714,
				["Ледяная стрела"] = 116,
				["Стрела ледяного огня"] = 44614,
				["Ледяная хватка"] = 102051,
				["Кольцо льда"] = 122,
				["Холод"] = 33395,
				["Стылая кровь"] = 12472,
				["Ледяная преграда"] = 11426,
				["Буря комет"] = 153595,
				["Кольцо обледенения"] = 157997,
			},
			["Buffs"] = {
				["Ледяные пальцы"] = 44544,
				["Колдовской поток"] = 116267,
				["Сильная струя воды"] = 135029,
				["Заморозка мозгов"] = 57761,
			},
			["Class"] = "MAGE",
		}

function bot:OnUpdate(g, list, modes)

	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
	
	if GetUnitName("focus") == nil or UnitIsDead("focus") then
		if IsInRaid() or IsInGroup() then
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		else
			list:Focus(g.target:CanAttack():Best())
			list:Focus(g.targets:CanAttack():Acceptable(g.party):Best())
		end
	end
	
	if GetUnitName("playerpet") == nil then
			list:Cast( "Призыв элементаля воды", g.player:CanUse("Призыв элементаля воды"):Best() )
	end
	
	list:Cast( "Антимагия", g.target:CanUse("Антимагия"):CanInterrupt():Best() )
	
	if modes.FrostLaw == "On" then
		list:Cast( "Ледяная хватка", g.focus:CanUse("Ледяная хватка"):Best() )
	end
	
	if modes.Heal == "On" then
		list:Cast( "Ледяная преграда", g.player:CanUse("Ледяная преграда"):Aura("Ледяная преграда", "mine", "self", "inverse"):Best() )
	end	
	
	if modes.Burst == "On" then
		list:Cast( "Ледяной шар", g.player:CanUse("Ледяной шар"):Best() )
		list:Cast( "Берсерк", g.player:CanUse("Берсерк"):Best() )
		list:Cast( "Стылая кровь", g.player:CanUse("Стылая кровь"):Best() )

	end

	if modes.AoE == "On" then
		list:Cast( "Конус холода", g.focus:CanUse("Конус холода"):Best() )
		list:Cast( "Кольцо льда", g.focus:CanUse("Кольцо льда"):Best() )
		list:Cast( "Ледяное копье", g.targets:CanUse("Ледяное копье"):Aura("Кольцо льда", "mine"):Best() )
	end
	
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Кольцо льда", "mine"):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Ледяная хватка", "mine"):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Кольцо обледенения", "mine"):Best() )
	
	list:Cast( "Буря комет", g.focus:CanUse("Буря комет"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )
	list:Cast( "Буря комет", g.focus:CanUse("Буря комет"):Aura("Колдовской поток", "mine", "self", "inverse"):Best() )

	--тут что то не так
	--list:Cast( "Ледяная бомба", g.focus:CanUse("Ледяная бомба"):Aura("Ледяные пальцы", "mine", "self"):Best() )
	list:Cast( "Кольцо обледенения", g.focus:CanUse("Кольцо обледенения"):Charges("Кольцо обледенения", 2):Best() )
	
	list:Cast( "Стрела ледяного огня", g.focus:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self", {stacks=2}):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Ледяные пальцы", "mine", "self", {stacks=2}):Best() )

	list:Cast( "Кольцо обледенения", g.focus:CanUse("Кольцо обледенения"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )
	
	list:Cast( "Стрела ледяного огня", g.focus:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self", {left=5}):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Ледяные пальцы", "mine", "self", {left=5}):Best() )
	
	list:Cast( "Стрела ледяного огня", g.focus:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Ледяные пальцы", "mine", "self"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )

	list:Cast( "Ледяная стрела", g.focus:CanUse("Ледяная стрела"):Moving(false):Best() )
	
	list:Cast( "Стрела ледяного огня", g.focus:CanUse("Стрела ледяного огня"):Aura("Заморозка мозгов", "mine", "self"):Best() )
	list:Cast( "Ледяное копье", g.focus:CanUse("Ледяное копье"):Aura("Ледяные пальцы", "mine", "self"):Best() )
	

	return list:Execute()
end

		
TBRegister(bot)