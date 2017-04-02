local bot ={
			["Talents"] = {
				["Последнее прибежище"] = 22543,
				["Пламенное приземление"] = 22541,
				["Трещина"] = 22509,
				["Взрывная душа"] = 22768,
				["Удар Бездны"] = 22502,
				["Узы Пустоты"] = 22548,
				["Печать цепей"] = 22510,
				["Пиршество душ"] = 22505,
				["Кормление демона"] = 22508,
				["Пламенная боль"] = 22503,
				["Клинок Скверны"] = 22324,
				["Извержение Скверны"] = 22540,
				["Ускоренные печати"] = 22511,
				["Бритвенно-острые шипы"] = 22504,
				["Средоточие печатей"] = 22546,
				["Раздирание души"] = 22770,
				["Призрачный барьер"] = 21902,
				["Опустошение Скверны"] = 22512,
				["Сожжение заживо"] = 22507,
				["Жаркий выброс"] = 22766,
				["Отражение клинков"] = 22513,
			},
			["Name"] = "Истребление",
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
			["Id"] = 1,
			["Spells"] = {
				["Удар Хаоса"] = 162794,
				["Поглощение магии"] = 183752,
				["Танец клинков"] = 188499,
				["Бросок боевого клинка"] = 185123,
				["Клинок Скверны"] = 232893,
				["Пронзающий взгляд"] = 198013,
				["Укус демона"] = 162243,
			},
			["Buffs"] = {
				["Демоническая свирепость"] = 226991,
			},
			["Class"] = "DEMONHUNTER",
		}

function bot:OnUpdate(g, list, modes)
	if IsMounted() then return end
	if modes.toggle.Stop then
		return
	end

	list:Cast( "Поглощение магии", g.target:CanUse("Поглощение магии"):CanInterrupt("first"):Best() )

  list:Cast( "Клинок Скверны", g.target:CanUse("Клинок Скверны"):Best() )
  list:Cast( "Танец клинков", g.target:CanUse("Танец клинков"):Toggle("AoE"):Best() )
  list:Cast( "Удар Хаоса", g.target:CanUse("Удар Хаоса"):Best() )
  list:Cast( "Укус демона", g.target:CanUse("Укус демона"):Best() )
  list:Cast( "Бросок боевого клинка", g.target:CanUse("Бросок боевого клинка"):Best() )

	return list:Execute()
end


TBRegister(bot)
