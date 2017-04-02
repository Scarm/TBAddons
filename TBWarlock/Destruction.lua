local bot = {
			["Talents"] = {
				["Огонь и сера"] = 22043,
				["Ревущее пламя"] = 22048,
				["Обратный поток"] = 22039,
				["Шкура демона"] = 22047,
				["Гримуар жертвоприношения"] = 19295,
				["Неистовство Тьмы"] = 19286,
				["Искоренение"] = 21695,
				["Демонический круг"] = 19280,
				["Ожог Тьмы"] = 22052,
				["Гримуар служения"] = 19294,
				["Гримуар верховной власти"] = 21182,
				["Катаклизм"] = 22480,
				["Посредник душ"] = 19293,
				["Темный пакт"] = 19288,
				["Жатва душ"] = 22046,
				["Сеяние хаоса"] = 22481,
				["Усиленный жизнеотвод"] = 22088,
				["Направленный демонический огонь"] = 22482,
				["Стремительный бег"] = 19291,
				["Лик тлена"] = 19285,
				["Обратная энтропия"] = 21181,
			},
			["Name"] = "Разрушение",
			["Id"] = 3,
			["Spells"] = {
				["Жизнеотвод"] = 1454,
				["Жертвенный огонь"] = 348,
				["Направленный демонический огонь"] = 196447,
				["Стрела Хаоса"] = 116858,
				["Огненный ливень"] = 5740,
				["Испепеление"] = 29722,
				["Поджигание"] = 17962,
        ["Похищение жизни"] = 234153,
			},
			["Buffs"] = {
				["Усиленный жизнеотвод"] = 235156,
				["Обратный поток"] = 117828,
				["Заряд молнии"] = 202886,
				["Поглощение души"] = 108366,
				["Камень Шаманов: Дух Волка"] = 155347,
				["Время настало!"] = 194627,
				["Защитник Стражей Хиджала"] = 93341,
				["Жертвенный огонь"] = 157736,
			},
			["Class"] = "WARLOCK",
      ["Buttons"] = {
        {
          ["Type"] = "trigger",
          ["Icon"] = "Interface\\Icons\\ABILITY_SEAL",
          ["Name"] = "Stop",
        }, -- [1]
        {
          ["Type"] = "trigger",
          ["Icon"] = "Interface\\Icons\\Ability_Warrior_Bladestorm",
          ["Name"] = "AoE",
        }, -- [2]
        {
          ["Type"] = "trigger",
          ["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
          ["Name"] = "Burst",
        }, -- [3]
      },
		}


function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

  list:Cast( "Жизнеотвод", g.player:CanUse("Жизнеотвод"):Condition(g.target:CanUse("Жертвенный огонь"):Best()):Talent("Усиленный жизнеотвод"):Aura("Усиленный жизнеотвод", "mine", "inverse", {time=3, bound=">"}):Best() )
  list:Cast( "Жертвенный огонь", g.target:CanUse("Жертвенный огонь"):Aura("Жертвенный огонь", "mine", "inverse"):LastCast("Жертвенный огонь", false):Best() )
  list:Cast( "Поджигание", g.target:CanUse("Поджигание"):Talent("Обратный поток"):Aura("Обратный поток", "mine", "self","inverse"):Best() )
  list:Cast( "Поджигание", g.target:CanUse("Поджигание"):Talent("Обратный поток",false):Best() )
  list:Cast( "Направленный демонический огонь", g.player:CanUse("Направленный демонический огонь"):Condition(g.target:CanUse("Жертвенный огонь"):Best()):Best() )
  list:Cast( "Стрела Хаоса", g.target:CanUse("Стрела Хаоса"):Best() )
  list:Cast( "Жизнеотвод", g.player:CanUse("Жизнеотвод"):Condition(g.target:CanUse("Порча"):Best()):Mana("<",70):Best() )
  list:Cast( "Похищение жизни", g.target:CanUse("Похищение жизни"):Moving(false):HP("<", 80, "self"):Best() )
  list:Cast( "Испепеление", g.target:CanUse("Испепеление"):Moving(false):Best() )

	return list:Execute()
end


TBRegister(bot)
