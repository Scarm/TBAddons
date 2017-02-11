local bot = {
			["Talents"] = {
				["Прославление"] = 21636,
				["Сияющая мощь"] = 22440,
				["Просветление"] = 19754,
				["Свет наару"] = 21750,
				["Ангел-хранитель"] = 21977,
				["Порицание"] = 22095,
				["Божественная звезда"] = 19760,
				["Постоянное обновление"] = 22136,
				["Божественное перышко"] = 22315,
				["Пробуждение Света"] = 19764,
				["Жизнь после смерти"] = 22562,
				["Сияние"] = 19763,
				["Благочестие"] = 21754,
				["Тело и разум"] = 22326,
				["Круг исцеления"] = 21638,
				["Связующее исцеление"] = 22327,
				["Благодарение"] = 21644,
				["Дорога Света"] = 19752,
				["Божественность"] = 19767,
				["Символ надежды"] = 21752,
				["Молитва отчаяния"] = 21976,
			},
			["Name"] = "Свет",
			["Buttons"] = {
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\Icons\\ABILITY_SEAL",
					["Name"] = "Stop",
				}, -- [1]
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					["Name"] = "Burst",
				}, -- [2]
				{
					Type = "spell",
					Spell = 34861, -- Слово Света: Освящение
				},
				{
					["Type"] = "trigger",
					["Icon"] = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
					["Name"] = "Preheal",
				}, -- [3]
			},
			["Id"] = 2,
			["Spells"] = {
				["Обновление"] = 139,
				["Сияющая мощь"] = 204263,
				["Исцеление"] = 2060,
				["Кара"] = 585,
				["Священный огонь"] = 14914,
				["Молитва восстановления"] = 33076,
				["Слово Света: Освящение"] = 34861,
				["Круг исцеления"] = 204883,
				["Кольцо света"] = 132157,
				["Слово Света: Безмятежность"] = 2050,
				["Быстрое исцеление"] = 2061,
				["Молитва исцеления"] = 596,
				["Слово Света: Наказание"] = 88625,
				["Очищение"] = 527,
			},
			["Class"] = "PRIEST",
			["Buffs"] = {
				["Молитва восстановления"] = 41635,
				["Отблеск Света"] = 77489,
				["Пробуждение Света"] = 114255,
				["Слово Света: Наказание"] = 200196,
				["Универсальность"] = 165833,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Божественность"] = 197030,
			},
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	TBLogValues.mode = nil

	local inRaid = IsInRaid()
	local inParty = IsInGroup()

	if not (inRaid or inParty) then
		return self:Solo(g, list, modes)
	end

	if g.player:AffectingCombat(true):Any() or g.tanks:AffectingCombat(true):Any() then
		TBLogValues.mode = "in combat"
		if inRaid == true then
			return self:RaidHeal(g, list, modes)
		else
			if inParty == true then
				return self:PartyHeal(g, list, modes)
			else
				return self:Solo(g, list, modes)
			end
		end
	else
		if modes.Preheal then
			return self:PreHeal(g, list, modes)
		end
	end

	return list:Execute()
end

function bot:Solo(g, list, modes)
	list:Cast( "Слово Света: Безмятежность", g.player:CanUse("Слово Света: Безмятежность"):HP("<",70):MinHP() )
	list:Cast( "Обновление", g.mainTank:CanUse("Обновление"):Aura("Обновление", "mine", "inverse"):HP("<",80):MinHP() )

	list:Cast( "Священный огонь", g.target:CanUse("Священный огонь"):Best() )
	list:Cast( "Слово Света: Наказание", g.target:CanUse("Слово Света: Наказание"):Best() )
	list:Cast( "Кара", g.target:CanUse("Кара"):Moving(false):Best() )
	return list:Execute()
end

function bot:RaidHeal(g, list, modes)

end

function bot:PartyHeal(g, list, modes)

	list:Cast( "Слово Света: Освящение", g.mainTank:CanUse("Слово Света: Освящение"):Enabled("Слово Света: Освящение"):Best() )

	--декурсинг
	list:Cast( "Очищение", g.player:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )
	list:Cast( "Очищение", g.tanks:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )
	list:Cast( "Очищение", g.party:CanUse("Очищение"):NeedDecurse("Magic","Disease"):MinHP() )

	list:Cast( "Слово Света: Безмятежность", g.party:CanUse("Слово Света: Безмятежность"):AuraGroup("full heal"):MinHP() )
	list:Cast( "Быстрое исцеление", g.party:CanUse("Быстрое исцеление"):AuraGroup("full heal"):LastCast("Быстрое исцеление", false):MinHP() )
	list:Cast( "Исцеление", g.party:CanUse("Исцеление"):AuraGroup("full heal"):MinHP() )

	list:Cast( "Обновление", g.mainTank:CanUse("Обновление"):Aura("Обновление", "mine", "inverse"):MinHP() )

	list:Cast( "Слово Света: Безмятежность", g.mainTank:CanUse("Слово Света: Безмятежность"):HP("<",50):MinHP() )
	list:Cast( "Быстрое исцеление", g.mainTank:CanUse("Быстрое исцеление"):Moving(false):HP("<",50):MinHP() )
	list:Cast( "Быстрое исцеление", g.mainTank:CanUse("Быстрое исцеление"):Moving(false):HP("<",60):LastCast("Быстрое исцеление", false):MinHP() )

	list:Cast( "Круг исцеления", g.player:Toggle("Burst"):CanUse("Круг исцеления"):MinHP() )
	list:Cast( "Молитва исцеления", g.player:Toggle("Burst"):CanUse("Молитва исцеления"):MinHP() )

	list:Cast( "Быстрое исцеление", g.party:CanUse("Быстрое исцеление"):Moving(false):HP("<",40):MinHP() )
	list:Cast( "Обновление", g.player:CanUse("Обновление"):Aura("Обновление", "mine", "inverse"):MinHP() )
	list:Cast( "Слово Света: Безмятежность", g.player:CanUse("Слово Света: Безмятежность"):HP("<",50):MinHP() )

	-- молитва восстановления только через танка
	list:Cast( "Молитва восстановления", g.mainTank:CanUse("Молитва восстановления"):Moving(false):Aura("Молитва восстановления", "mine", "inverse"):MinHP() )
	list:Cast( "Круг исцеления", g.player:Condition( g.party:HP("<",90):Count(4):Any() ):CanUse("Круг исцеления"):MinHP() )
	list:Cast( "Молитва исцеления", g.player:Condition( g.party:HP("<",90):Count(4):Any() ):CanUse("Молитва исцеления"):MinHP() )



	list:Cast( "Быстрое исцеление", g.party:CanUse("Быстрое исцеление"):Moving(false):HP("<",60):MinHP() )

	list:Cast( "Исцеление", g.party:CanUse("Исцеление"):Moving(false):HP("<",70):MinHP() )
	list:Cast( "Исцеление", g.mainTank:CanUse("Исцеление"):Moving(false):HP("<",85):MinHP() )

	--list:Cast( "Священный огонь", g.mainTank:CanUse("Священный огонь"):Best() )
	--list:Cast( "Слово Света: Наказание", g.mainTank:CanUse("Слово Света: Наказание"):Best() )
	--list:Cast( "Кара", g.mainTank:CanUse("Кара"):Moving(false):Best() )
	list:Cast( "Обновление", g.party:CanUse("Обновление"):Aura("Обновление", "mine", "inverse"):HP("<",90):MinHP() )

	return list:Execute()
end


function bot:PreHeal(g, list, modes)

end



TBRegister(bot)
