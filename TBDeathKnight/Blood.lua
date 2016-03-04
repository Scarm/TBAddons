local bot = {
			["Name"] = "Кровь",
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
				{
					["ToolTip"] = "On",
					["Icon"] = "Interface\\ICONS\\INV_Misc_GroupNeedMore.blp",
					["GroupId"] = "Party",
				}, -- [4]
			},
			["Id"] = 1,
			["Spells"] = {
				["Темная власть"] = 56222,
				["Заморозка разума"] = 47528,
				["Вскипание крови"] = 50842,
				["Удар смерти"] = 49998,
				["Вытягивание чумы"] = 123693,
				["Хватка смерти"] = 49576,
				["Вспышка болезни"] = 77575,
				["Кровоотвод"] = 45529,
				["Лик смерти"] = 47541,
				["Ледяное прикосновение"] = 45477,
				["Удар чумы"] = 45462,
			},
			["Buffs"] = {
				["Решимость"] = 158300,
				["Кровавая чума"] = 55078,
				["Хватка смерти"] = 51399,
				["Власть крови"] = 48263,
				["Алая Плеть"] = 81141,
				["Тень смерти"] = 164047,
				["Щит крови"] = 77535,
				["Озноб"] = 55095,
				["Запах крови"] = 50421,
				["Заряд крови"] = 114851,
			},
			["Class"] = "DEATHKNIGHT",
		}
	


function BaseGroup:BloodRunes(bound, runes)
	local r = GetRuneCount(1) + GetRuneCount(2)

	if (bound == "<" and r <= runes) or (bound == ">" and r >= runes) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:FrostRunes(bound, runes)
	local r = GetRuneCount(3) + GetRuneCount(4)

	if (bound == "<" and r <= runes) or (bound == ">" and r >= runes) then
		return self
	end
	return self:CreateDerived()
end

function BaseGroup:UnholyRunes(bound, runes)
	local r = GetRuneCount(5) + GetRuneCount(6)

	if (bound == "<" and r <= runes) or (bound == ">" and r >= runes) then
		return self
	end
	return self:CreateDerived()
end

function bot:OnUpdate(g, list, modes)
	
	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
	
	list:Cast( "Заморозка разума", g.target:CanUse("Заморозка разума"):CanInterrupt():Best() )
	
	list:Cast( "Вспышка болезни", g.target:CanUse("Вспышка болезни"):Aura("Кровавая чума", "mine", "inverse"):Best() )
	list:Cast( "Вспышка болезни", g.target:CanUse("Вспышка болезни"):Aura("Озноб", "mine", "inverse"):Best() )
	
	list:Cast( "Удар чумы", g.target:CanUse("Удар чумы"):Aura("Кровавая чума", "mine", "inverse"):Best() )
	list:Cast( "Ледяное прикосновение", g.target:CanUse("Ледяное прикосновение"):Aura("Озноб", "mine", "inverse"):Best() )
	
	if modes.AoE == "On" then
		list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Energy(">", 80):Best() )
		
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):HP("<", 80, "self"):Best() )
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):FrostRunes(">", 2):Best())
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):UnholyRunes(">", 2):Best())
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):CanUse("Вытягивание чумы"):HP("<", 80, "self"):Best())
		
		list:Cast( "Вытягивание чумы", g.target:CanUse("Вытягивание чумы"):FrostRunes("<", 0):UnholyRunes("<", 0):HP("<", 80, "self"):Best() )
		list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Energy(">", 50):Best() )
		
		list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар смерти"):Aura("Алая Плеть", "mine", "self"):Best() )
		list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар смерти"):Best() )
		
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):BloodRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):FrostRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):UnholyRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )		
	else
		list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Energy(">", 80):Best() )
		
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):HP("<", 80, "self"):Best() )
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):FrostRunes(">", 2):Best())
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):UnholyRunes(">", 2):Best())
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):CanUse("Вытягивание чумы"):Best())
		list:Cast( "Удар смерти", g.target:CanUse("Удар смерти"):Aura("Заряд крови", "mine", "self", {stacks=10}):Best() )

		
		list:Cast( "Вытягивание чумы", g.target:CanUse("Вытягивание чумы"):FrostRunes("<", 0):UnholyRunes("<", 0):Best() )
		list:Cast( "Лик смерти", g.target:CanUse("Лик смерти"):Energy(">", 50):Best() )
		
		list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар смерти"):BloodRunes(">", 2):Best() )
		list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар смерти"):Aura("Алая Плеть", "mine", "self"):Best() )
		list:Cast( "Вскипание крови", g.target:CanUse("Вскипание крови"):InSpellRange("Удар смерти"):BloodRunes(">", 1):Aura("Заряд крови", "mine", "self", {stacks=11}):Best() )
		
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):BloodRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):FrostRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )
		list:Cast( "Кровоотвод", g.player:CanUse("Кровоотвод"):UnholyRunes("<", 0):Aura("Заряд крови", "mine", "self", {stacks=5}):Best() )
	
	end
		
	return list:Execute()
end	

		
TBRegister(bot)