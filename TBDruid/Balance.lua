DruidBalance = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Звездный огонь"] = 2912,
				["Гнев"] = 5176,
				["Звездный поток"] = 78674,
				["Лунный огонь"] = 8921,
				["Солнечный огонь"] = 93402,
				["Облик лунного совуха"] = 24858,
				["Сила Природы"] = 106737,
				["Ураган"] = 16914,
			},
			["Class"] = "DRUID",
			["Buffs"] = {
			},
		}
		
		
function DruidBalance:OnUpdate()
	if IsMounted() or GetShapeshiftForm() == 6 or GetShapeshiftForm() == 4 or GetShapeshiftForm() == 2 then return end
	

	if GetShapeshiftForm() ~= 5 and TBCanUse("Облик лунного совуха") then
		return TBCast("Облик лунного совуха")
	end
	
	
end
		
		
		
TBRegister(DruidBalance)