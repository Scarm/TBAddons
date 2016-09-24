local bot = {
			["Talents"] = {
				["Зарождение"] = 22165,
				["Массовое оплетение"] = 18576,
				["Душа леса"] = 21710,
				["Родство с силой зверя"] = 22367,
				["Щит Кенария"] = 18574,
				["Обилие"] = 18569,
				["Родство со стражем"] = 22160,
				["Воплощение: Древо Жизни"] = 21707,
				["Обновление"] = 19283,
				["Расцвет"] = 22404,
				["Родство с балансом"] = 22366,
				["Стремительный рывок"] = 18571,
				["Астральный скачок"] = 18570,
				["Момент ясности"] = 22403,
				["Тайфун"] = 18577,
				["Проращивание"] = 21704,
				["Изобилие"] = 18572,
				["Мощное оглушение"] = 21778,
				["Каменная кора"] = 21651,
				["Весенние цветы"] = 21716,
				["Внутренняя гармония"] = 21713,
			},
			["Name"] = "Исцеление",
			["Id"] = 4,
			["Spells"] = {
				["Железная кора"] = 102342,
				["Облик лунного совуха"] = 197625,
				["Омоложение"] = 774,
				["Быстрое восстановление"] = 18562,
				["Буйный рост"] = 48438,
				["Лунный огонь"] = 8921,
				["Целительное прикосновение"] = 5185,
				["Солнечный огонь"] = 93402,
				["Лунный удар"] = 197628,
				["Солнечный гнев"] = 5176,
				["Природный целитель"] = 88423,
				["Жизнецвет"] = 33763,
				["Звездный поток"] = 197626,
				["Восстановление"] = 8936,
				["Период цветения"] = 145205,
				["Дубовая кожа"] = 22812,
				["Сущность Г'ханира"] = 208253,
				["Щит Кенария"] = 102351,
			},
			["Buffs"] = {
				["Лунное могущество"] = 164547,
				["Солнечное могущество"] = 164545,
				["Ясность мысли"] = 16870,
				["Лунный огонь"] = 164812,
				["Омоложение (зарождение)"] = 155777,
				["Семя жизни"] = 48504,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Знак Призрачной Луны"] = 159678,
				["Защитник гильдии"] = 97341,
				["Изнеможение"] = 57723,
				["Изобилие"] = 207640,
				["Солнечный огонь"] = 164815,
				["Щит Кенария"] = 102352,
			},
			["Class"] = "DRUID",
			["Buttons"] = {
				[1] = {
					Type = "trigger",
					Icon = "Interface\\Icons\\ABILITY_SEAL",
					Name = "Stop",
				},
				[2] = {
					Type = "trigger",
					Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
					Name = "Burst",
				},
				[3] = {
					Type = "spell",
					Spell = 145205, -- Период цветения
				},
				[4] = {
					Type = "spell",
					Spell = 208253, -- Сущность Г'ханира
				},
				[5] = {
					Type = "trigger",
					Icon = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
					Name = "Preheal",
				},
				[6] = {
					Type = "trigger",
					Icon = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
					Name = "Dmg",
				},			},
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
	if GetShapeshiftForm() == 4 then
		list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",70):MinHP() )
		list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",50):MinHP() )

		list:Cast( "Звездный поток", g.target:CanUse("Звездный поток"):Moving(false):Best() )
		list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", "inverse"):Best() )
		list:Cast( "Солнечный огонь", g.target:CanUse("Солнечный огонь"):Aura("Солнечный огонь", "mine", "inverse"):Best() )
		list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )
		list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Moving(false):Best() )
		list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Moving(false):Best() )
		list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Moving(false):Best() )

		list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Moving(false):Best() )
		list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Moving(false):Best() )

		return list:Execute()
	end

	-- Жизнецвет висит всегда, т.к. он может прокнуть "Ясность мысли"
	list:Cast( "Жизнецвет", g.mainTank:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", "inverse"):MinHP() )

	-- Одно омоложение весим, если по танку прошел хоть какой то урон
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse", {time=5, bound=">"})
			:Aura("Омоложение (зарождение)", "mine", "inverse", {time=5, bound=">"})
			:HP("<",95)
			:MinHP() )

	-- Если у танка еще меньше ХП - тогда весим второе омоложение, если взят талант
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse", {time=5, bound=">"})
			:HP("<",85)
			:MinHP() )

	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse", {time=5, bound=">"})
			:HP("<",85)
			:MinHP() )
	-- Дополнительно, если есть возможность - всадим в него Восстановление для еще одного хота
	list:Cast( "Восстановление",
			g.mainTank:CanUse("Восстановление")
			:Moving(false)
			:Aura("Ясность мысли", "mine", "self")
			:HP("<",75)
			:Aura("Восстановление", "mine", "inverse", {time=3, bound=">"})
			:LastCast("Восстановление", false)
			:MinHP() )
	-- Если у танка меньше 60% ХП - тогда уже нам без разницы, сколько стоит Восстановление, Бафф болжен быть
	list:Cast( "Восстановление",
			g.mainTank:CanUse("Восстановление")
			:Moving(false)
			:HP("<",60)
			:Aura("Восстановление", "mine", "inverse", {time=3, bound=">"})
			:LastCast("Восстановление", false)
			:MinHP() )
	----------------
	list:Cast( "Быстрое восстановление", g.mainTank:CanUse("Быстрое восстановление"):HP("<",50):MinHP() )
	list:Cast( "Восстановление",
			g.mainTank:CanUse("Восстановление")
			:Moving(false)
			:HP("<",50)
			:LastCast("Восстановление", false, "total")
			:MinHP() )
	list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",50):MinHP() )

	--[[
	list:Cast( "Звездный поток", g.target:CanUse("Звездный поток"):Moving(false):Best() )
	list:Cast( "Лунный огонь", g.target:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", "inverse"):Best() )
	list:Cast( "Солнечный огонь", g.target:CanUse("Солнечный огонь"):Aura("Солнечный огонь", "mine", "inverse"):Best() )
	list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )
	list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Moving(false):Best() )
	list:Cast( "Солнечный гнев", g.target:CanUse("Солнечный гнев"):Moving(false):Best() )
	list:Cast( "Лунный удар", g.target:CanUse("Лунный удар"):Moving(false):Best() )

	list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Moving(false):Best() )
	list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Moving(false):Best() )
	--]]
	return list:Execute()
end

function bot:RaidHeal(g, list, modes)
	if GetShapeshiftForm() == 4 then

		return list:Execute()
	end

		list:Cast( "Жизнецвет", g.mainTank:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", "inverse"):MinHP() )
		-- танк
		list:Cast( "Омоложение",
				g.mainTank:CanUse("Омоложение")
				:Aura("Омоложение", "mine", "inverse", {time=3, bound=">"})
				:Aura("Омоложение (зарождение)", "mine", "inverse", {time=3, bound=">"})
				:HP("<",99)
				:MinHP() )
		list:Cast( "Омоложение",
				g.mainTank:CanUse("Омоложение")
				:Aura("Омоложение", "mine", "inverse", {time=3, bound=">"})
				:HP("<",90)
				:MinHP() )
		list:Cast( "Омоложение",
				g.mainTank:CanUse("Омоложение")
				:Talent("Зарождение", true)
				:Aura("Омоложение (зарождение)", "mine", "inverse", {time=3, bound=">"})
				:HP("<",90)
				:MinHP() )
	-- Раскидываем омоложения по пати
	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:HP("<",90)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:Aura("Омоложение", "mine", "inverse")
			:MinHP() )

	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse")
			:HP("<",80)
			:MinHP() )

	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:HP("<",80)
			:MinHP() )
end

function bot:PartyHeal(g, list, modes)
	if GetShapeshiftForm() == 4 then
		list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",70):MinHP() )
		list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",50):MinHP() )

		list:Cast( "Звездный поток", g.mainTank:CanUse("Звездный поток"):Moving(false):Best() )
		list:Cast( "Лунный огонь", g.mainTank:CanUse("Лунный огонь"):Aura("Лунный огонь", "mine", "inverse"):Best() )
		list:Cast( "Солнечный огонь", g.mainTank:CanUse("Солнечный огонь"):Aura("Солнечный огонь", "mine", "inverse"):Best() )
		list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )
		list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Moving(false):Best() )
		list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Moving(false):Best() )
		list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Moving(false):Best() )

		return list:Execute()
	end
	--декурсинг
	list:Cast( "Природный целитель", g.player:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )
	list:Cast( "Природный целитель", g.tanks:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )
	list:Cast( "Природный целитель", g.party:CanUse("Природный целитель"):NeedDecurse("Curse","Magic","Poison"):MinHP() )

	list:Cast( "Период цветения", g.player:CanUse("Период цветения"):Enabled("Период цветения"):Best() )
	list:Cast( "Сущность Г'ханира", g.player:CanUse("Сущность Г'ханира"):Enabled("Сущность Г'ханира"):Best() )

	list:Cast( "Быстрое восстановление", g.party:CanUse("Быстрое восстановление"):AuraGroup("full heal"):LastCast("Быстрое восстановление", false):MinHP() )
	list:Cast( "Восстановление", g.party:CanUse("Восстановление"):AuraGroup("full heal"):LastCast("Восстановление", false):MinHP() )
	list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):AuraGroup("full heal"):MinHP() )



	list:Cast( "Жизнецвет", g.mainTank:CanUse("Жизнецвет"):Aura("Жизнецвет", "mine", "inverse"):MinHP() )
	-- С танком все плохо, хилить без хотов никак не получится
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse", {time=3, bound=">"})
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:HP("<",50)
			:MinHP() )
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse")
			:HP("<",50)
			:MinHP() )
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:HP("<",50)
			:MinHP() )
	list:Cast( "Восстановление",
			g.mainTank:CanUse("Восстановление")
			:Moving(false)
			:HP("<",50)
			:Aura("Восстановление", "mine", "inverse")
			:LastCast("Восстановление", false)
			:MinHP() )
	list:Cast( "Щит Кенария", g.mainTank:CanUse("Щит Кенария"):HP("<",50):MinHP() )
	list:Cast( "Быстрое восстановление", g.mainTank:CanUse("Быстрое восстановление"):Aura("Щит Кенария", "mine", "inverse"):HP("<",50):MinHP() )
	list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",50):MinHP() )

	-- С ДД все плохо
	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:HP("<",50)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:Aura("Омоложение", "mine", "inverse")
			:MinHP() )
	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse")
			:HP("<",50)
			:MinHP() )
	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:HP("<",50)
			:MinHP() )
	list:Cast( "Восстановление",
			g.mainTank:CanUse("Восстановление")
			:Moving(false)
			:HP("<",50)
			:Aura("Восстановление", "mine", "inverse")
			:LastCast("Восстановление", false)
			:MinHP() )
	list:Cast( "Быстрое восстановление", g.mainTank:CanUse("Быстрое восстановление"):HP("<",60):MinHP() )
	list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",60):MinHP() )
	list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",50):MinHP() )
	list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",60):LastCast("Целительное прикосновение", false):MinHP() )

	-- Теперь все не так плохо, обрабатываем среднюю тяжесть
	-- танк
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse", {time=3, bound=">"})
			:Aura("Омоложение (зарождение)", "mine", "inverse", {time=3, bound=">"})
			:HP("<",99)
			:MinHP() )
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse", {time=3, bound=">"})
			:HP("<",90)
			:MinHP() )
	list:Cast( "Омоложение",
			g.mainTank:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse", {time=3, bound=">"})
			:HP("<",90)
			:MinHP() )

	-- Раскидываем омоложения по пати
	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:HP("<",85)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:Aura("Омоложение", "mine", "inverse")
			:MinHP() )

	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Aura("Омоложение", "mine", "inverse")
			:HP("<",70)
			:MinHP() )

	list:Cast( "Омоложение",
			g.party:CanUse("Омоложение")
			:Talent("Зарождение", true)
			:Aura("Омоложение (зарождение)", "mine", "inverse")
			:HP("<",70)
			:MinHP() )

	--list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",70):MinHP() )
	--list:Cast( "Целительное прикосновение", g.party:CanUse("Целительное прикосновение"):HP("<",80):LastCast("Целительное прикосновение", false):MinHP() )

	list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",70):MinHP() )
	list:Cast( "Целительное прикосновение", g.mainTank:CanUse("Целительное прикосновение"):HP("<",80):LastCast("Целительное прикосновение", false):MinHP() )

	----------------

	list:Cast( "Звездный поток", g.mainTank:CanUse("Звездный поток"):Toggle("Dmg"):Mana(">", 90):Moving(false):Best() )
	list:Cast( "Лунный огонь", g.mainTank:CanUse("Лунный огонь"):Toggle("Dmg"):Aura("Лунный огонь", "mine", "inverse"):Mana(">", 90):Best() )
	list:Cast( "Солнечный огонь", g.mainTank:CanUse("Солнечный огонь"):Toggle("Dmg"):Aura("Солнечный огонь", "mine", "inverse"):Mana(">", 90):Best() )
	list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Toggle("Dmg"):Aura("Солнечное могущество", "mine", "self"):LastCast("Солнечный гнев", false):Moving(false):Best() )
	list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Toggle("Dmg"):Aura("Лунное могущество", "mine", "self"):LastCast("Лунный удар", false):Mana(">", 90):Moving(false):Best() )
	list:Cast( "Солнечный гнев", g.mainTank:CanUse("Солнечный гнев"):Toggle("Dmg"):Moving(false):Best() )
	list:Cast( "Лунный удар", g.mainTank:CanUse("Лунный удар"):Toggle("Dmg"):Moving(false):Mana(">", 90):Best() )

	return list:Execute()
end


function bot:PreHeal(g, list, modes)

end



TBRegister(bot)
