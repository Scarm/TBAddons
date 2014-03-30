DruidRestor = {
			["Unique"] = {
			},
			["Id"] = 4,
			["Spells"] = {
				["Буйный рост"] = 48438,
				["Омоложение"] = 774,
				["Жизнецвет"] = 33763,
				["Гнев"] = 5176,
			},
			["Buffs"] = {
			},
			["Class"] = "DRUID",
		}
		
function DruidRestor:OnUpdate()
	if IsMounted() or GetShapeshiftForm() == 6 or GetShapeshiftForm() == 4 or GetShapeshiftForm() == 2 then return end
	

end
		
		
		
TBRegister(DruidRestor)