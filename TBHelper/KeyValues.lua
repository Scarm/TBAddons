function TBKeyValuesFill(values)

	values["1"] = 1

	local gr = TBGroups()

	values["LastCommand"] = IndicatorFrame.LastCommand
	values["LastCommandTime"] = string.format("%.1f", GetTime() - (IndicatorFrame.LastCommandTime or GetTime()))
	values["CommandDelay"] = ToString(IndicatorFrame.LastCommandDiffStr)

	--[[
	for k,v in pairs(TBLogValues) do
		values[k] = ToString(v)
	end
--]]

	--for k,v in pairs(IndicatorFrame.LoS.Banned or {}) do
	--	values[k] = ToString(v)
	--end
--	values["chagres"] = UnitPower("player", SPELL_POWER_ARCANE_CHARGES)

	-- [[
	values["fail"] = ToString(TBLogValues["can use fail"])
	values["spell name"] = ToString(TBLogValues["spell name"])
	values["can use success"] = ToString(TBLogValues["can use success"])
	values["TargetType"] = ToString(TBLogValues["TargetType"])
	values["IsUsableSpell"] = ToString(TBLogValues["IsUsableSpell"])

	values["IsHarmfulSpell"] = ToString(TBLogValues["IsHarmfulSpell"])
	values["IsHelpfulSpell"] = ToString(TBLogValues["IsHelpfulSpell"])
	values["UnitCanAssist"] = ToString(TBLogValues["UnitCanAssist"])
	values["UnitCanAttack"] = ToString(TBLogValues["UnitCanAttack"])
	--]]

	-- [[
	values["stacks count"] = TBLogValues["stacks count"]
	values["stacks condition"] = TBLogValues["stacks condition"]
	values["stacks bound"] = TBLogValues["stacks bound"]
	--]]

	--values["isnil"] = ToString(TBLogValues["spell is null"])

	--values["overlay"] = ToString(IsSpellOverlayed(6572))

	--values["aura"] = ToString(TBLogValues["aura"])

	--values["UnitThreatSituation"] = ToString(UnitThreatSituation("player","target"))
	if BaseGroupHelper.LastCast.LastSpellTime and GetTime() > BaseGroupHelper.LastCast.LastSpellTime then
		BaseGroupHelper.LastCast.LastSpell = nil
	end
	values["LastSpell"] = ToString(BaseGroupHelper.LastCast.LastSpell)

	--values["Частица"] = ToString(gr.party:Aura("Частица Света", "mine"):MinHP())


	for i = 1,GetNumSavedInstances(),1 do
		local nm,_,_,diff,locked = GetSavedInstanceInfo(i)
		if diff == 23 and not locked then
			values[nm] = ToString(diff).."("..ToString(locked)..")"
		end
	end

	--[[
	for i= 1,6,1 do
		local start, duration, runeReady = GetRuneCooldown(i)
		local et = start + duration - GetTime()
		if runeReady then
			et = 0
		end

		values["rune"..i] = ToString( et )
	end
	--]]

	--values["ShapeshiftForm"] = ToString(GetShapeshiftForm())
	--values["in raid"] = ToString(IsInRaid())
	--values["in party"] = ToString(IsInGroup())
	--values["mode"] = ToString(TBLogValues.mode)

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
