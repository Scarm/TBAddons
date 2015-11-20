local bot = {
			["Name"] = "Огонь",
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
			},
			["Id"] = 2,
			["Spells"] = {
				["Ледяная преграда"] = 11426,
				["Антимагия"] = 2139,
				["Возгорание"] = 11129,
				["Пламенный взрыв"] = 108853,
				["Огненная глыба"] = 11366,
				["Ожог"] = 2948,
				["Чарокрад"] = 30449,
				["Огненный шар"] = 133,
				["Дыхание дракона"] = 31661,
				["Взрывная волна"] = 157981,
			},
			["Class"] = "MAGE",
			["Buffs"] = {
				["Огненная глыба!"] = 48108,
				["Возгорание"] = 83853,
				["Колдовской поток"] = 116267,
				["Воспламенение"] = 12654,
				["Усиленная пиротехника"] = 157644,
				["Разогрев"] = 48107,
			},
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
	
	list:Cast( "Антимагия", g.targets:CanUse("Антимагия"):CanInterrupt():Best() )
	
	
	if modes.Heal == "On" then
		list:Cast( "Ледяная преграда", g.player:CanUse("Ледяная преграда"):Aura("Ледяная преграда", "mine", "self", "inverse"):Best() )
	end	
	
	if modes.Burst == "On" then

	end

	if modes.AoE == "On" then

	end
	list:Cast( "Взрывная волна", g.focus:CanUse("Взрывная волна"):Charges("Взрывная волна", 2):Best() )

	list:Cast( "Огненная глыба", g.focus:CanUse("Огненная глыба"):Aura("Разогрев", "mine", "self"):Aura("Огненная глыба!", "mine", "self"):Best() )

	list:Cast( "Огненная глыба", g.focus:CanUse("Огненная глыба"):Aura("Огненная глыба!", "mine", "self"):Aura("Колдовской поток", "mine", "self", "inverse"):Best() )
	list:Cast( "Огненная глыба", g.focus:CanUse("Огненная глыба"):Aura("Огненная глыба!", "mine", "self"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )
	
	list:Cast( "Пламенный взрыв", g.focus:CanUse("Пламенный взрыв"):Aura("Разогрев", "mine", "self"):Best() )
	list:Cast( "Возгорание", g.focus:CanUse("Возгорание"):Aura("Разогрев", "mine", "self"):Best() )
	
	list:Cast( "Взрывная волна", g.focus:CanUse("Взрывная волна"):Aura("Колдовской поток", "mine", "self", {stacks=4}):Best() )
	list:Cast( "Взрывная волна", g.focus:CanUse("Взрывная волна"):Aura("Колдовской поток", "mine", "self", "inverse"):Best() )
	
	list:Cast( "Огненный шар", g.focus:CanUse("Огненный шар"):Moving(false):Best() )
	list:Cast( "Ожог", g.focus:CanUse("Ожог"):Best() )


	return list:Execute()
end

		
TBRegister(bot)