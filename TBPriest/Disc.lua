PriestDisc = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Быстрое исцеление"] = 2061,
				["Архангел"] = 81700,
				["Исцеление"] = 2060,
				["Кара"] = 585,
				["Молитва восстановления"] = 33076,
				["Исчадие Тьмы"] = 34433,
				["Подавление боли"] = 33206,
				["Кольцо света"] = 132157,
				["Исповедь"] = 47540,
				["Божественная вспышка"] = 175702,
				["Молитва исцеления"] = 596,
				["Ясность воли"] = 152118,
				["Очищение"] = 527,
				["Священный огонь"] = 14914,
				["Слово силы: Щит"] = 17,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
				["Ослабленная душа"] = 6788,
				["Приверженность"] = 81661,
				["Всесильный архангел"] = 172359,
				["Лишнее время"] = 59889,
			},
			["Buttons"] = {
				[1] = {
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					ToolTip = "Off",
					GroupId = "Run",
				},
				[2] = {
					Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					ToolTip = "On",
					GroupId = "Burst",
				},
				[3] = {
					Icon = "Interface\\Icons\\DRUID_ABILITY_WILDMUSHROOM_A",
					ToolTip = "On",
					GroupId = "Mushroom",
					default = 1
				},					
			},
		}

function BaseGroup:MaxDist()

	local dist = 0
	local unit = nil
	for key,value in pairs(self) do
		local d = distance("player", key)
		if d and d > dist then
			dist = d
			unit = value
		end
	end
	return unit

end

function BaseGroup:ClarityOfWill(perc)
	local result = self:CreateDerived()
	
	for key,value in pairs(self) do
		local val = select(15,UnitAura(key,"Ясность воли")) or 0
		
		if 	100 * val / UnitHealthMax("player")	< perc then
			result[key] = value
		end
	end
	
	return result
end

function BaseGroup:HolyNova(party)
	local c, d = distToParty("player", party, 12)
	
	if c <5 then
		return self:CreateDerived()
	end
	return self	
end
		
function PriestDisc:OnUpdate(g, list, modes)

	if IsMounted() and UnitAura("player", "Северный боевой волк") == nil then return end

	if modes.Run == "Off" then 
		return 
	end
	
	--декурсинг	
	list:Cast( "Очищение", g.player:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )	
	list:Cast( "Очищение", g.tanks:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )	
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )	
	
	
	if  g.player:AffectingCombat():MinHP() or g.tanks:AffectingCombat():MinHP() then
		list:Cast( "Архангел",   g.player:CanUse("Архангел"):Aura("Приверженность", "mine", "self", nil, nil, 5):MinHP() )
	
		list:Cast( "Слово силы: Щит",   g.tanks:ManaLimit(20):CanUse("Слово силы: Щит"):Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )		
		--поддерживаем на себе лишнее время
		list:Cast( "Слово силы: Щит",   g.party:ManaLimit(20):CanUse("Слово силы: Щит"):HasBossDebuff():Aura("Лишнее время", "mine", "self", "inverse"):Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )	

		list:Cast( "Быстрое исцеление", g.tanks:Moving("false"):RangeHP(0,80):CanUse("Быстрое исцеление"):Aura("Всесильный архангел", "mine", "self"):TBLastCast("Быстрое исцеление"):MinHP() )
		list:Cast( "Исповедь", g.tanks:CanAssist():RangeHP(0,70):CanUse("Исповедь"):MinHP() )		
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving("false"):RangeHP(0,70):Aura("Ясность воли", "mine", nil, "inverse",5):TBLastCast("Ясность воли"):MinHP() )		
		list:Cast( "Быстрое исцеление", g.tanks:Moving("false"):RangeHP(0,50):CanUse("Быстрое исцеление"):MinHP() )
		list:Cast( "Быстрое исцеление", g.tanks:Moving("false"):RangeHP(0,70):CanUse("Быстрое исцеление"):TBLastCast("Быстрое исцеление"):MinHP() )
		list:Cast( "Быстрое исцеление", g.player:Moving("false"):RangeHP(0,50):CanUse("Быстрое исцеление"):MinHP() )
		
		list:Cast( "Священный огонь", g.mainTank:CanUse("Священный огонь"):Best() )

		list:Cast( "Слово силы: Щит",  g.party:CanUse("Слово силы: Щит"):NeedFullHeal():Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )
		list:Cast( "Ясность воли",     g.party:CanUse("Ясность воли"):NeedFullHeal():Moving("false"):Aura("Ослабленная душа"):Aura("Слово силы: Щит", "mine", nil, "inverse"):Aura("Ясность воли", "mine", nil, "inverse"):TBLastCast("Ясность воли"):MinHP() )
		list:Cast( "Исповедь",         g.party:CanUse("Исповедь"):NeedFullHeal():CanAssist():MinHP() )
		list:Cast( "Быстрое исцеление",g.player:CanUse("Быстрое исцеление"):NeedFullHeal():Moving("false"):RangeHP(0,70):TBLastCast("Быстрое исцеление"):MinHP() )
		list:Cast( "Исцеление",        g.party:CanUse("Исцеление"):NeedFullHeal():Moving("false"):MinHP() )
		
		list:Cast( "Исповедь", g.party:CanAssist():RangeHP(0,70):CanUse("Исповедь"):MinHP() )
		list:Cast( "Исцеление", g.party:RangeHP(0,60):Moving("false"):ManaLimit(70):CanUse("Исцеление"):MinHP() )

		list:Cast( "Божественная вспышка", g.party:AvgRangeHP(0,95):CanUse("Божественная вспышка"):MaxDist() )
		list:Cast( "Молитва восстановления", g.tanks:Moving("false"):CanUse("Молитва восстановления"):Aura("Молитва восстановления", "mine", nil, "inverse"):MinHP() )
		list:Cast( "Молитва восстановления", g.party:Moving("false"):ManaLimit(70):CanUse("Молитва восстановления"):Aura("Молитва восстановления", "mine", nil, "inverse"):MinHP() )
		
		-- DD
		list:Cast( "Кара", g.mainTank:CanUse("Кара"):Moving("false"):Aura("Архангел", "mine", "self", "inverse"):Aura("Приверженность", "mine", "self", "inverse", nil, 5):TBLastCast("Кара"):Best() )		
		list:Cast( "Кара", g.mainTank:CanUse("Кара"):Moving("false"):Aura("Архангел", "mine", "self", "inverse"):Aura("Приверженность", "mine", "self", "inverse",5):Best() )
		--	
		list:Cast( "Слово силы: Щит",   g.party:HasBossDebuff():CanUse("Слово силы: Щит"):Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )	
		list:Cast( "Ясность воли",   g.party:HasBossDebuff():CanUse("Ясность воли"):Aura("Ослабленная душа", nil, nil, "inverse"):Aura("Слово силы: Щит", "mine", nil, "inverse"):Aura("Ясность воли", "mine", nil, "inverse"):TBLastCast("Ясность воли"):MinHP() )	
		list:Cast( "Кольцо света", g.player:CanUse("Кольцо света"):HolyNova( g.party:RangeHP(0,95) ):MinHP() )
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving("false"):Aura("Ясность воли", "mine", nil, "inverse",5):TBLastCast("Ясность воли"):MinHP() )				
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving("false"):ManaLimit(70):Aura("Архангел", "mine", "self"):ClarityOfWill(40):MinHP() )		
	end

	if modes.Burst == "On" then
		if UnitAffectingCombat("player") then
			list:Cast( "Слово силы: Щит",   g.party:CanUse("Слово силы: Щит"):HasBossDebuff():Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )
			list:Cast( "Слово силы: Щит",   g.party:CanUse("Слово силы: Щит"):Aura("Ослабленная душа", nil, nil, "inverse"):MinHP() )
		end
	else

	end


	return list:Execute()

end
		
		
		
TBRegister(PriestDisc)