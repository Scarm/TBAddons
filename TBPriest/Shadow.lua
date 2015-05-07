PriestShadow = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Иссушение разума"] = 48045,
				["Взрыв разума"] = 8092,
				["Слово силы: Щит"] = 17,
				["Всепожирающая чума"] = 2944,
				["Слово Тьмы: Боль"] = 589,
				["Прикосновение вампира"] = 34914,
				["Слово Тьмы: Смерть"] = 32379,
				["Облик Тьмы"] = 15473,
				["Кара"] = 585,
				["Пронзание разума"] = 73510,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
				["Наступление Тьмы"] = 87160,
			},
			["Buttons"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Run",
					},
					[2] = {
						Icon = "Interface\\Icons\\SPELL_SHADOW_MINDSHEAR",
						ToolTip = "On",
						GroupId = "AoE",
						
					},
					[3] = {
						Icon = "Interface\\Icons\\SPELL_SHADOW_DEVOURINGPLAGUE",
						ToolTip = "On",
						GroupId = "DP",
						default = 1
					},					
					
					[4] = {
						Icon = "Interface\\Icons\\SPELL_PRIEST_MINDSPIKE",
						ToolTip = "Mindspike",
						GroupId = "Rotation",
						default = 1
					},

					[5] = {
						Icon = "Interface\\Icons\\SPELL_SHADOW_SHADOWWORDPAIN",
						ToolTip = "DoT",
						GroupId = "Rotation",
					},
					[6] = {
						Icon = "Interface\\Icons\\ABILITY_PRIEST_SHADOWYAPPARITION",
						ToolTip = "Spirits",
						GroupId = "Rotation",
					},
				},
		}

function BaseGroup:OrbLimit(orbs, isFalse)
	if isFalse then
		if UnitPower('player', SPELL_POWER_SHADOW_ORBS) < orbs then
			return self	
		end
		return self:CreateDerived()
	else
		if UnitPower('player', SPELL_POWER_SHADOW_ORBS) >= orbs then
			return self
		end
		return self:CreateDerived()
	end
end		

		
function PriestShadow:OnUpdate(g, list, modes)
	if IsMounted() then return end
	
	if modes.Run == "Off" then 
		return 
	end
	list:Cast( "Облик Тьмы", g.player:CanUse("Облик Тьмы"):Aura("Облик Тьмы", "mine", "self", "inverse"):Best() )
	
	if modes.Rotation == "Mindspike" then	

		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )
		list:Cast( "Всепожирающая чума", g.target:RangeHP(0, 20):CanUse("Всепожирающая чума", "yes"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
		list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", "yes"):Best() )
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):Best() )
		list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):Aura("Всепожирающая чума", "mine", nil, "inverse"):CanUse("Пронзание разума"):Best() )
		list:Cast( "Кара", g.target:RangeHP(0, 20):CanUse("Кара"):Best() )
		
		list:Cast( "Слово Тьмы: Боль", g.target:IsFocus():CanUse("Слово Тьмы: Боль"):OrbLimit(5):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Прикосновение вампира", g.target:IsFocus():CanUse("Прикосновение вампира"):OrbLimit(5):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )			
		list:Cast( "Всепожирающая чума", g.target:IsFocus():CanUse("Всепожирающая чума", "yes"):Aura("Слово Тьмы: Боль", "mine"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )
		
		list:Cast( "Пронзание разума", g.target:IsFocus():Aura("Слово Тьмы: Боль", "mine", nil, "inverse"):Aura("Прикосновение вампира", "mine", nil, "inverse"):Aura("Всепожирающая чума", "mine", nil, "inverse"):CanUse("Пронзание разума"):Best() )
		list:Cast( "Пронзание разума", g.target:IsFocus():Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		list:Cast( "Кара", g.target:IsFocus():CanUse("Кара"):Best() )
		
		list:Cast( "Пронзание разума", g.target:Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )			
		list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
		--[[
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )	
		list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):Best() )
		list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", "yes"):Best() )
		
		list:Cast( "Пронзание разума", g.target:Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		--list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):CanUse("Пронзание разума"):Best() )
		
		list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )	
		list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
		--]]
		
	elseif modes.Rotation == "DoT" then
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )	
		list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):OrbLimit(5):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
		list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", "yes"):Best() )
		list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):Best() )
		
		if modes.DP == "On" then
			list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):OrbLimit(3):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 6):Best() )
			list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):OrbLimit(3):Aura("Прикосновение вампира", "mine", nil, "inverse", 6):TBLastCast("Прикосновение вампира"):Best() )	
			list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
		end
		
		list:Cast( "Пронзание разума", g.target:Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
		list:Cast( "Кара", g.target:CanUse("Кара"):Aura("Всепожирающая чума", "mine"):Best() )
		list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):CanUse("Пронзание разума"):Best() )
		
		list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
		list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )	
		list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
	
	elseif modes.Rotation == "Spirits" then
		
		if modes.AoE == "On" then
			list:Cast( "Иссушение разума", g.target:CanUse("Иссушение разума"):Best() )
		else
			list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):TBLastCast("Слово Тьмы: Смерть", "yes"):Best() )	
			list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):OrbLimit(5):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
			list:Cast( "Взрыв разума", g.target:CanUse("Взрыв разума", "yes"):Best() )
			list:Cast( "Слово Тьмы: Смерть", g.target:CanUse("Слово Тьмы: Смерть", "yes"):Best() )
			
			if modes.DP == "On" then
				list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):OrbLimit(3):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 6):Best() )
				list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):OrbLimit(3):Aura("Прикосновение вампира", "mine", nil, "inverse", 6):TBLastCast("Прикосновение вампира"):Best() )	
				list:Cast( "Всепожирающая чума", g.target:CanUse("Всепожирающая чума", "yes"):Aura("Всепожирающая чума", "mine", nil, "inverse"):Best() )	
			end
			
			list:Cast( "Пронзание разума", g.target:Aura("Наступление Тьмы", "mine", "self"):CanUse("Пронзание разума", "yes"):Best() )
			list:Cast( "Кара", g.target:CanUse("Кара"):Aura("Всепожирающая чума", "mine"):Best() )

			list:Cast( "Пронзание разума", g.target:RangeHP(0, 20):CanUse("Пронзание разума"):Best() )
			
			list:Cast( "Слово Тьмы: Боль", g.target:CanUse("Слово Тьмы: Боль"):Aura("Слово Тьмы: Боль", "mine", nil, "inverse", 3):Best() )
			list:Cast( "Прикосновение вампира", g.target:CanUse("Прикосновение вампира"):Aura("Прикосновение вампира", "mine", nil, "inverse", 4):TBLastCast("Прикосновение вампира"):Best() )	
			
					
			list:Cast( "Кара", g.target:CanUse("Кара"):Best() )
		end
	end
	
	return list:Execute()
end
		
		
		
TBRegister(PriestShadow)