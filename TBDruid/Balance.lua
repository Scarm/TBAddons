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
	

	if GetShapeshiftForm() ~= 5 and TBCanUse("Облик лунного совуха", "player") then
		return TBCast("Облик лунного совуха","target")
	end
	
	if GetEclipseDirection() == "sun" then
        if TBCanUse("Лунный огонь","target") and TBDebuff("Лунный огонь",1,"target")== nil then           
            return TBCast("Лунный огонь","target")
        end
    
        if TBCanUse("Солнечный огонь","target") and TBDebuff("Солнечный огонь",1,"target")== nil then
            return TBCast("Солнечный огонь","target")
        end
    
        
        if TBCanUse("Звездный поток","target") then
            return TBCast("Звездный поток","target")
        end
        
        if TBCanUse("Звездный огонь","target") then
            return TBCast("Звездный огонь","target")
        end
        
    else
        if TBCanUse("Солнечный огонь","target") and TBDebuff("Солнечный огонь",1,"target")== nil then           
            return TBCast("Солнечный огонь","target")
        end

        if TBCanUse("Лунный огонь","target") and TBDebuff("Лунный огонь",1,"target")== nil then
            return TBCast("Лунный огонь","target")
        end
    
        if TBCanUse("Звездный поток","target") then
            return TBCast("Звездный поток","target")
        end
        
        if TBCanUse("Гнев","target") then
            return TBCast("Гнев","target")
        end
  
    end	
end
		
		
		
TBRegister(DruidBalance)