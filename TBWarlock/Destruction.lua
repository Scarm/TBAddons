WarlockDestr = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Ожог Тьмы"] = 17877,
				["Стрела Тьмы"] = 686,
				["Узы Тьмы"] = 109773,
				["Стрела Хаоса"] = 116858,
				["Увечащие тени"] = 175707,
				["Порча"] = 172,
				["Поджигание"] = 17962,
				["Огонь и сера"] = 108683,
			},
			["Buffs"] = {
			},
			["Class"] = "WARLOCK",
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
			},
		}
	
function BaseGroup:EmbersLimit(embers)
	if UnitPower('player', SPELL_POWER_BURNING_EMBERS) >= embers then
		return self
	end
	return self:CreateDerived()
end	
	
function WarlockDestr:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end
		
	if modes.AoE == "On" then
	
	end
	
	list:Cast( "Ожог Тьмы", g.target:CanUse("Ожог Тьмы"):Best() )	
	list:Cast( "Порча", g.target:CanUse("Порча"):Aura("Порча", "mine", nil, "inverse", 3):TBLastCast("Порча"):Best() )
	list:Cast( "Поджигание", g.target:CanUse("Поджигание"):Aura("Поджигание", "mine", nil, "inverse", 3):Best() )
	
	list:Cast( "Стрела Хаоса", g.target:CanUse("Стрела Хаоса"):EmbersLimit(3):Best() )
	list:Cast( "Стрела Тьмы", g.target:CanUse("Стрела Тьмы"):Best() )
	
	
	return list:Execute()
end
		
		
		
TBRegister(WarlockDestr)