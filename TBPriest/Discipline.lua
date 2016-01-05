local bot = {
			["Name"] = "Послушание",
			["Id"] = 1,
			["Spells"] = {
				["Ясность воли"] = 152118,
				["Быстрое исцеление"] = 2061,
				["Архангел"] = 81700,
				["Исцеление"] = 2060,
				["Слово силы: Щит"] = 17,
				["Кара"] = 585,
				["Слово силы: Утешение"] = 129250,
				["Молитва восстановления"] = 33076,
				["Рассеивание заклинаний"] = 528,
				["Каскад"] = 121135,
				["Кольцо света"] = 132157,
				["Исповедь"] = 47540,
				["Очищение"] = 527,
				["Молитва исцеления"] = 596,
				["Скакун Тираэля"] = 107203,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
				["Всесильный архангел"] = 172359,
				["Молитва восстановления"] = 41635,
				["Ослабленная душа"] = 6788,
				["Тело и душа"] = 65081,
				["Видения будущего"] = 162913,
				["Лишнее время"] = 59889,
				["Божественное покровительство"] = 47753,
				["Приверженность"] = 81661,
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
					Icon = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
					ToolTip = "On",
					GroupId = "preheal",
				},											
			},
		}
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

function bot:OnUpdate(g, list, modes)
	
	if IsMounted() then return end	
	if modes.Run == "Off" then 
		return 
	end
	
	--декурсинг	
	list:Cast( "Очищение", g.player:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )	
	list:Cast( "Очищение", g.tanks:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )	
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )

	if g.player:AffectingCombat(true):MinHP() or g.tanks:AffectingCombat(true):MinHP() then
	
		if modes.Burst == "On" then	
			list:Cast( "Слово силы: Щит",   g.tanks:Mana(">", 20):CanUse("Слово силы: Щит"):Aura("Ослабленная душа", "inverse"):MinHP() )		
			list:Cast( "Исповедь", g.tanks:CanAssist():HP("<", 70):CanUse("Исповедь"):MinHP() )		

			list:Cast( "Буйный рост", 
						g.party
						:Moving(false)
						:CanUse("Буйный рост")
						:HP("<",85)
						:BastForAoE(4,30) )
		else
		list:Cast( "Архангел",   g.player:CanUse("Архангел"):Aura("Приверженность", "mine", "self", {stacks=5}):MinHP() )
		
		list:Cast( "Слово силы: Щит",   g.tanks:Mana(">", 20):CanUse("Слово силы: Щит"):Aura("Ослабленная душа","inverse"):MinHP() )		
		--поддерживаем на себе лишнее время
		list:Cast( "Слово силы: Щит",   g.party:Mana(">", 20):CanUse("Слово силы: Щит"):Aura("Лишнее время", "mine", "self", "inverse"):Aura("Ослабленная душа", "inverse"):MinHP() )	

		list:Cast( "Быстрое исцеление", g.tanks:Moving(false):HP("<", 80):CanUse("Быстрое исцеление"):Aura("Всесильный архангел", "mine", "self"):LastCast("Быстрое исцеление",false):MinHP() )		
		list:Cast( "Исповедь", g.tanks:CanAssist():HP("<", 70):CanUse("Исповедь"):MinHP() )
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving(false):HP("<", 70):Aura("Ясность воли", "mine", "inverse",{skip=5}):LastCast("Ясность воли", false):MinHP() )		
		
		list:Cast( "Быстрое исцеление", g.tanks:Moving(false):HP("<", 50):CanUse("Быстрое исцеление"):MinHP() )
		list:Cast( "Быстрое исцеление", g.tanks:Moving(false):HP("<", 70):CanUse("Быстрое исцеление"):LastCast("Быстрое исцеление", false):MinHP() )
		list:Cast( "Быстрое исцеление", g.player:Moving(false):HP("<", 50):CanUse("Быстрое исцеление"):MinHP() )
		
		list:Cast( "Слово силы: Утешение", g.mainTank:CanUse("Слово силы: Утешение"):Best() )
		
		list:Cast( "Исповедь", g.party:CanAssist():HP("<", 70):CanUse("Исповедь"):MinHP() )
		list:Cast( "Быстрое исцеление", g.player:Moving(false):HP("<", 40):CanUse("Быстрое исцеление"):MinHP() )

		list:Cast( "Молитва исцеления", 
					g.party
					:Moving(false)
					:CanUse("Молитва исцеления")
					:HP("<",60)
					:BastForAoE(3,30) )	
					
		list:Cast( "Исцеление", g.party:HP("<", 60):Moving(false):CanUse("Исцеление"):MinHP() )		
		
		list:Cast( "Божественная вспышка", g.party:HP("<",85):CanUse("Божественная вспышка"):BastForAoE(4,30) )
	
		-- DD
		list:Cast( "Кара", g.mainTank:CanUse("Кара"):Moving(false):Aura("Архангел", "mine", "self", "inverse"):Aura("Приверженность", "mine", "self", "inverse", nil, {stacks=5}):LastCast("Кара", false, "total"):Best() )		
		list:Cast( "Кара", g.mainTank:CanUse("Кара"):Moving(false):Aura("Архангел", "mine", "self", "inverse"):Aura("Приверженность", "mine", "self", "inverse", {skip=5}):Best() )

		list:Cast( "Исцеление", g.party:HP("<", 70):Moving(false):CanUse("Исцеление"):MinHP() )		
 		
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving(false):Aura("Ясность воли", "mine", "inverse",{skip=5}):LastCast("Ясность воли", false):MinHP() )				
		list:Cast( "Ясность воли",   g.tanks:CanUse("Ясность воли"):Moving(false):Aura("Архангел", "mine", "self"):ClarityOfWill(40):MinHP() )	

		list:Cast( "Исцеление", g.party:HP("<", 80):Moving(false):CanUse("Исцеление"):LastCast("Исцеление", false):MinHP() )		
		
		end
	end
	
	return list:Execute()
end	
		
TBRegister(bot)