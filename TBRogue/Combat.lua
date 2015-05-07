RogueCombat = {
			["Unique"] = {
			},
			["Id"] = 2,
			["Spells"] = {
				["Внезапный удар"] = 8676,
				["Кровавый вихрь"] = 121411,
				["Бросок"] = 121733,
				["Пробивающий удар"] = 84617,
				["Коварный удар"] = 1752,
				["Незаметность"] = 1784,
				["Отравляющий укол"] = 5938,
				["Шквал клинков"] = 13877,
				["Потрошение"] = 2098,
				["Заживление ран"] = 73651,
				["Мясорубка"] = 5171,
				["Пинок"] = 1766,
				["Метка смерти"] = 137619,
			},
			["Class"] = "ROGUE",
			["Buffs"] = {
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
						Icon = "Interface\\Icons\\ABILITY_ROGUE_RECUPERATE",
						ToolTip = "On",
						GroupId = "Healing",
						default = 1
					},					
				},
		}
	
function BaseGroup:ComboPoints(points)
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		
		if GetComboPoints("player", key)>=points then
			result[key] = value
		end
	end
	
	return result
end

function RogueCombat:OnUpdate(g, list, modes)
	if IsMounted() then return end

	if modes.Run == "Off" then 
		return 
	end
	
	if GetShapeshiftForm() == 0 and g.target:CanUse("Бросок"):Best() then
		list:Cast( "Незаметность", g.player:CanUse("Незаметность"):Best() )
	end	
	
	-- удар-стартер
	list:Cast( "Внезапный удар", g.targets:AutoAttacking("true"):CanUse("Внезапный удар"):Best() )
	
	if modes.AoE == "On" then
		list:Cast( "Шквал клинков", g.player:CanUse("Шквал клинков"):Aura("Шквал клинков", "mine", "self", "inverse"):Best() )
	else
		list:Cast( "Шквал клинков", g.player:Aura("Шквал клинков", "mine", "self"):Best() )
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	
	list:Cast( "Пинок", g.targets:CanUse("Пинок"):CanInterrupt():Best() )
	list:Cast( "Метка смерти", g.target:CanUse("Метка смерти"):Best() )
		
	list:Cast( "Пробивающий удар", g.target:CanUse("Пробивающий удар"):Aura("Пробивающий удар", "mine", nil, "inverse", 3):Best() )
	list:Cast( "Мясорубка", g.player:CanUse("Мясорубка"):Aura("Мясорубка", "mine", "self", "inverse", 3):Best() )
	if modes.Healing == "On" then
		list:Cast( "Заживление ран", g.player:CanUse("Заживление ран"):RangeHP(0, 80):Aura("Заживление ран", "mine", "self", "inverse", 3):Best() )
	end
	
	if modes.AoE == "On" then
		list:Cast( "Кровавый вихрь", g.targets:CanUse("Кровавый вихрь"):ComboPoints(5):Best() )
		list:Cast( "Коварный удар", g.targets:CanUse("Коварный удар"):Best() )	
	else
		list:Cast( "Потрошение", g.targets:CanUse("Потрошение"):ComboPoints(5):Best() )
		list:Cast( "Коварный удар", g.targets:CanUse("Коварный удар"):Best() )	
	end
	
	return list:Execute()
end	
		
TBRegister(RogueCombat)
	