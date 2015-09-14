MonkBM = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Рука-копье"] = 116705,
				["Дзуки"] = 100780,
				["Защита"] = 115295,
				["Лапа тигра"] = 100787,
				["Удар бочонком"] = 121253,
				["Устранение вреда"] = 115072,
				["Пламенное дыхание"] = 115181,
				["Отвар неуловимости"] = 115308,
				["Нокаутирующий удар"] = 100784,
				["Сверкающая нефритовая молния"] = 117952,
				["Танцующий журавль"] = 101546,
				["Очищающий отвар"] = 119582,
				["Ваятель ци"] = 175693,
			},
			["Buffs"] = {
				["Сила тигра"] = 125359,
				["Скрытые резервы"] = 115307,
			},
			["Class"] = "MONK",
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
	
function BaseGroup:ChiLimit(chi)
	if UnitPower('player', SPELL_POWER_CHI) >= chi then
		return self
	end
	return self:CreateDerived()
end	
	
function MonkBM:OnUpdate(g, list, modes)
	if IsMounted() and UnitAura("player", "Северный боевой волк") == nil then return end
	
	if modes.Run == "Off" then 
		return 
	end
	
	if not UnitAffectingCombat("player") then
		return list:Execute()
	end
	list:Cast( "Рука-копье", g.target:CanUse("Рука-копье"):CanInterrupt():Best() )
	
	list:Cast( "Защита", g.player:CanUse("Защита"):Best() )
	list:Cast( "Отвар неуловимости", g.player:CanUse("Отвар неуловимости"):HealthLimit(80):Best() )
	

	
	if modes.AoE == "On" then
		list:Cast( "Нокаутирующий удар", g.target:CanUse("Нокаутирующий удар"):ChiLimit(4):Aura("Скрытые резервы", "mine", "self", "inverse", 2):Best() )	
		--list:Cast( "Пламенное дыхание", g.player:CanUse("Пламенное дыхание"):ChiLimit(4):Best() )
		list:Cast( "Ваятель ци", g.target:CanUse("Ваятель ци"):Best() )

		list:Cast( "Устранение вреда", g.target:CanUse("Устранение вреда"):HealthLimit(80):Best() )	
		list:Cast( "Удар бочонком", g.target:CanUse("Удар бочонком"):Best() )
		list:Cast( "Лапа тигра", g.target:CanUse("Лапа тигра"):Aura("Сила тигра", "mine", "self", "inverse", 3):Best() )
		list:Cast( "Танцующий журавль", g.player:CanUse("Танцующий журавль"):ManaLimit(80):Best() )
		list:Cast( "Дзуки", g.target:CanUse("Дзуки"):ManaLimit(80):Best() )		
	else
		list:Cast( "Ваятель ци", g.target:CanUse("Ваятель ци"):Best() )
		list:Cast( "Устранение вреда", g.target:CanUse("Устранение вреда"):HealthLimit(80):Best() )
		list:Cast( "Нокаутирующий удар", g.target:CanUse("Нокаутирующий удар"):ChiLimit(3):Aura("Скрытые резервы", "mine", "self", "inverse", 2):Best() )
		list:Cast( "Удар бочонком", g.target:CanUse("Удар бочонком"):Best() )
		list:Cast( "Лапа тигра", g.target:CanUse("Лапа тигра"):Aura("Сила тигра", "mine", "self", "inverse", 3):Best() )	
		list:Cast( "Дзуки", g.target:CanUse("Дзуки"):ManaLimit(80):Best() )
		list:Cast( "Нокаутирующий удар", g.target:CanUse("Нокаутирующий удар"):ChiLimit(3):Best() )
		end
	
	return list:Execute()
end	
		
TBRegister(MonkBM)