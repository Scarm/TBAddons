function TBKeyValuesFill(values)

	values["1"] = 1
	
	local gr = TBGroups()
	
	values["LastCommand"] = IndicatorFrame.LastCommand
	
	values["LastCastTarget"] = IndicatorFrame.LastTarget
	
	values["UnitAffectingCombat"] = ToString(UnitAffectingCombat("target"))
	
	values["focusname"] = ToString(GetUnitName("focus"))
	
	values["UnitThreatSituation"] = ToString(UnitThreatSituation("player","target"))
	


	--[[
	for i=1,40,1 do
		local name = UnitAura("target",i)
		local id = select(11, UnitAura("target",i))
		
		if name then
			--values["+"..id] = name
			 values["+"..id] = GetSpellLink(id)
		end
	end
	--]]
	--[[
	for i=1,40,1 do
		local name = UnitAura("target",i,"HARMFUL")
		local id = select(11, UnitAura("target",i,"HARMFUL"))
		
		if name then
			--values["-"..id] = name
			values["-"..id] = GetSpellLink(id)
		end
	end	
	--]]

end

function TBKeyValuesUpdate()
	local variables = {}
	TBKeyValuesFill(variables)
	
	local _,height = TBHelperNamesString:GetFont()
	local strings = 0

	local names = ''
	local values = ''
	
	for name,value in pairs(variables) do
		if strings>0 then
			names = names.."\n"
			values = values.."\n"
		end
		names = names..name
		values = values..value
		strings = strings + 1		
	end
	
	
	TBHelperNamesString:SetText(names)
	TBHelperValuesString:SetText(values)
	
	TBHelperValuesFrame:SetHeight(strings * height)
	TBHelperValuesFrame:SetWidth( TBHelperNamesString:GetStringWidth() + TBHelperValuesString:GetStringWidth()+10)
	TBHelperNamesString:SetWidth(TBHelperNamesString:GetStringWidth())
	TBHelperValuesString:SetWidth(TBHelperValuesString:GetStringWidth())
end