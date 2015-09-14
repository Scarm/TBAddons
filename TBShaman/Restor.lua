ShamanRestor = {
			["Unique"] = {
			},
			["Id"] = 3,
			["Spells"] = {
				["Пронизывающий ветер"] = 57994,
				["Очищение духа"] = 51886,
				["Удар духов стихии"] = 117014,
				["Цепное исцеление"] = 1064,
				["Тотем исцеляющего потока"] = 5394,
				["Быстрина"] = 61295,
				["Молния"] = 403,
				["Исцеляющий всплеск"] = 8004,
				["Щит земли"] = 974,
				["Огненный шок"] = 8050,
				["Стихийный удар"] = 73899,
				["Высвободить чары жизни"] = 73685,
				["Волна исцеления"] = 77472,
				["Щит молний"] = 324,
			},
			["Class"] = "SHAMAN",
			["Buffs"] = {
				["Приливные волны"] = 53390,
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
		
function ShamanRestor:OnUpdate(g, list, modes)
	
	if IsMounted() and UnitAura("player", "Северный боевой волк") == nil then return end
	
	if modes.Run == "Off" then 
		return 
	end

	if not (g.player:AffectingCombat():MinHP() or g.tanks:AffectingCombat():MinHP()) then
		return list:Execute()
	end
	
	list:Cast( "Щит молний", g.player:CanUse("Щит молний"):Aura("Щит молний", "mine", "self", "inverse"):Best() )
	list:Cast( "Пронизывающий ветер", g.target:CanUse("Пронизывающий ветер"):CanInterrupt():Best() )

	if g.focus:MinHP() then
		list:Cast( "Щит земли",   g.focus:CanUse("Щит земли"):Aura("Щит земли", "mine", nil, "inverse"):MinHP() )
	else
		list:Cast( "Щит земли",   g.mainTank:CanUse("Щит земли"):Aura("Щит земли", "mine", nil, "inverse"):MinHP() )
	end
	
	--декурсинг	
	list:Cast( "Очищение духа", g.player:CanUse("Очищение духа"):NeedDecurse("Curse","Magic"):MinHP() )	
	list:Cast( "Очищение духа", g.tanks:CanUse("Очищение духа"):NeedDecurse("Curse","Magic"):MinHP() )		
	list:Cast( "Очищение духа", g.party:CanUse("Очищение духа"):NeedDecurse("Curse","Magic"):MinHP() )	

	
	list:Cast( "Исцеляющий всплеск", g.tanks:RangeHP(0,60):Moving("false"):CanUse("Исцеляющий всплеск"):Aura("Приливные волны", "mine", "self"):TBLastCast("Исцеляющий всплеск"):MinHP() )
	list:Cast( "Исцеляющий всплеск", g.player:RangeHP(0,40):Moving("false"):CanUse("Исцеляющий всплеск"):Aura("Приливные волны", "mine", "self"):TBLastCast("Исцеляющий всплеск"):MinHP() )

	list:Cast( "Быстрина",   g.mainTank:CanUse("Быстрина"):Aura("Быстрина", "mine", nil, "inverse"):MinHP() )
	list:Cast( "Быстрина",   g.tanks:CanUse("Быстрина"):Aura("Быстрина", "mine", nil, "inverse"):MinHP() )
	list:Cast( "Быстрина",   g.party:CanUse("Быстрина"):NeedFullHeal():Aura("Быстрина", "mine", nil, "inverse"):MinHP() )
	list:Cast( "Быстрина",   g.party:CanUse("Быстрина"):RangeHP(0, 80):Aura("Быстрина", "mine", nil, "inverse"):MinHP() )
	list:Cast( "Тотем исцеляющего потока",   g.player:AvgRangeHP(0,95):CanUse("Тотем исцеляющего потока"):MinHP() )

	list:Cast( "Исцеляющий всплеск", g.party:CanUse("Исцеляющий всплеск"):RangeHP(0, 30):ManaLimit(60):Aura("Быстрина", "mine"):TBLastCast("Исцеляющий всплеск"):MinHP() )
	list:Cast( "Волна исцеления", g.party:CanUse("Волна исцеления"):RangeHP(0, 50):Aura("Быстрина", "mine"):TBLastCast("Волна исцеления"):MinHP() )
	
	list:Cast( "Цепное исцеление", g.party:CanUse("Цепное исцеление"):ManaLimit(60):RangeHP(0, 90):Aura("Приливные волны", "mine", "self", "inverse"):TBLastCast("Цепное исцеление"):BastForAoE(3,30) )
	list:Cast( "Цепное исцеление", g.party:CanUse("Цепное исцеление"):ManaLimit(60):RangeHP(0, 80):Aura("Быстрина", "mine", nil, "inverse"):TBLastCast("Цепное исцеление"):BastForAoE(4,30) )
	list:Cast( "Цепное исцеление", g.party:CanUse("Цепное исцеление"):ManaLimit(90):RangeHP(0, 90):Aura("Быстрина", "mine", nil, "inverse"):BastForAoE(4,30) )

	list:Cast( "Удар духов стихии", g.mainTank:CanUse("Удар духов стихии"):Moving("false"):Best() )	
	
	list:Cast( "Исцеляющий всплеск", g.party:CanUse("Исцеляющий всплеск"):NeedFullHeal():RangeHP(0,50):MinHP() )
	list:Cast( "Исцеляющий всплеск", g.party:CanUse("Исцеляющий всплеск"):NeedFullHeal():RangeHP(0,70):TBLastCast("Исцеляющий всплеск"):MinHP() )
	list:Cast( "Волна исцеления", g.party:CanUse("Волна исцеления"):NeedFullHeal():Moving("false"):MinHP() )
	
	list:Cast( "Исцеляющий всплеск", g.party:CanUse("Исцеляющий всплеск"):RangeHP(0,40):ManaLimit(60):Aura("Приливные волны", "mine", "self"):TBLastCast("Исцеляющий всплеск"):MinHP() )
	list:Cast( "Волна исцеления", g.party:CanUse("Волна исцеления"):RangeHP(0, 70):Aura("Быстрина", "mine", nil, "inverse"):MinHP() )
	list:Cast( "Волна исцеления", g.party:CanUse("Волна исцеления"):RangeHP(0, 70):Aura("Быстрина", "mine"):TBLastCast("Волна исцеления"):MinHP() )
	list:Cast( "Волна исцеления", g.party:CanUse("Волна исцеления"):RangeHP(0, 80):Aura("Быстрина", "mine", nil, "inverse"):TBLastCast("Волна исцеления"):MinHP() )
	list:Cast( "Волна исцеления", g.tanks:CanUse("Волна исцеления"):RangeHP(0, 85):TBLastCast("Волна исцеления"):MinHP() )
	
	
	
	list:Cast( "Огненный шок", g.focus:CanUse("Огненный шок"):Aura("Огненный шок", "mine", nil, "inverse", 6):Best() )
	list:Cast( "Огненный шок", g.mainTank:CanUse("Огненный шок"):Aura("Огненный шок", "mine", nil, "inverse", 6):Best() )
	list:Cast( "Стихийный удар", g.focus:CanUse("Стихийный удар"):Best() )
	list:Cast( "Стихийный удар", g.mainTank:CanUse("Стихийный удар"):Best() )
	list:Cast( "Молния", g.focus:CanUse("Молния"):Best() )
	list:Cast( "Молния", g.mainTank:CanUse("Молния"):Best() )
	return list:Execute()
end	
		
TBRegister(ShamanRestor)