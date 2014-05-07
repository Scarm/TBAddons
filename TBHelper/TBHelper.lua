SLASH_TBHELPER1 = '/tbh';
function SlashCmdList.TBHELPER(msg, editbox)
    if msg == 'hidespells' then
		TBHelperFrame:Hide()
	end
	
	if msg == 'showspells' then
		TBHelperFrame:Show()
	end
	
	if msg == 'names' then
		TBGroupNames()
	end
end



function TBGroupNames()
	print("party names:")
	
	player, party, focus, targets = TBGroups()
	
	print("party:")
	for key,value in pairs(party:Aura("Омоложение", 1, nil, nil)) do
		print(key)
	end
	
end

function TBCheckDistance(self)

end

function TBPrintEvent(self,event,...)
	print(event,...)
end

function TBHelperOnEvent(self,event,...)
	--print(event)
	if event == 'PLAYER_LOGIN' then
		TBHelperOnPlayerLogin(self,event,...)
	end	
	if event == 'ACTIVE_TALENT_GROUP_CHANGED' then
		TBHelperOnTalentChanged(self)
	end
end

function TBLists(frame)
	local _,height = frame.SpellsString:GetFont()
	local text = ""
	local strings = 0
	for name,spellId in pairs(frame.SpellsTable) do
		if text~="" then
			text = text.."\n"
		end
		text = text..name.."("..spellId..")"
		strings = strings + 1
	end
	
	frame.SpellsString:SetHeight(strings * height)
	frame.SpellsString:SetText(text)
	
end

function TBHelperOnReceiveDrag(self)	
	if CursorHasSpell() then
		local _,_,_,spellId = GetCursorInfo()		
		local name = GetSpellInfo(spellId)
		
		if self.SpellsTable[name] == nil then
			print("Добавляем спелл: ",name," ", spellId)
			self.SpellsTable[name] = spellId
		else
			print("Удаляем спелл: ",name," ", spellId)
			self.SpellsTable[name] = nil			
		end
		
		TBLists(self)
		
		ClearCursor()
	end
end

function TBHelperOnPlayerLogin(self,event,...)
	if TBHelperData == nil then
		TBHelperData = {}						
	end
	
	if TBHelperData.Specializations == nil then
		TBHelperData.Specializations = {}		
	end	
	
	local _,class = UnitClass("player")	

	for specId = 1, GetNumSpecializations(), 1 do
		local id, name, description, icon, background, role = GetSpecializationInfo(specId)
		
		if TBHelperData.Specializations[name] == nil then
			TBHelperData.Specializations[name] = {}
		end
		
		spec = TBHelperData.Specializations[name]		
		spec.Class = class
		spec.Id = specId		
		if spec.Spells == nil then
			spec.Spells = {}	
		end
		if spec.Buffs == nil then
			spec.Buffs = {}	
		end	
		if spec.Unique == nil then
			spec.Unique = {}	
		end
	end
	
	TBHelperOnTalentChanged(self)
end

function TBHelperOnTalentChanged(self)
	if IsLoggedIn() then
		local id, name = GetSpecializationInfo(GetSpecialization())
		TBHelperSpellFrame.SpellsTable = TBHelperData.Specializations[name].Spells
		TBHelperBuffFrame.SpellsTable = TBHelperData.Specializations[name].Buffs
		TBHelperUniqueFrame.SpellsTable = TBHelperData.Specializations[name].Unique
		
		TBHelperSpellFrame.SpellsString = TBHelperSpellFrameList
		TBHelperBuffFrame.SpellsString = TBHelperBuffFrameList
		TBHelperUniqueFrame.SpellsString = TBHelperUniqueFrameList
		TBLists(TBHelperSpellFrame)
		TBLists(TBHelperBuffFrame)
		TBLists(TBHelperUniqueFrame)
	end	
end

function TBFillValues(values)

	values["1"] = 1
	player, party, focus, targets = TBGroups()
	
	--values["healing"] = UnitGetIncomingHeals("player")
	--values["absorbs"] = UnitGetTotalAbsorbs("player")
	
	for key,value in pairs(PanelFrame.Groups) do
		values[key] = value
	end
	
	--[[
	local result = targets:CanUse("Гнев")
	
	
	for key,value in pairs(result) do
		--values[key] = string.format("%d", 100 * UnitHealth(key) / UnitHealthMax(key))
		values[key] = string.format("%d", 100 * UnitHealth(key))
	end
	
	
	values["minHP"] = "nil"
	local target = result:MinHP()
	if target then
		values["minHP"] = target.value
	end
	
	values["LastCommand"] = IndicatorFrame.LastCommand or "nil"	
	--]]
	--[[
	local party = TBPartyList()
	for key,value in pairs(party) do
		value.HP = string.format("%d", 100 * UnitHealth(key) / UnitHealthMax(key))
	end
	local filtered = TBHasBuff("Омоложение",1,TBCanUse("Омоложение", party))
	for key,value in pairs(filtered) do
		values[key] = value.HP
	end	
	--]]
end

function TBHelperUpdateValues()
	local variables = {}
	TBFillValues(variables)
	
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
	
	TBHelperValuesFrame:SetHeight(strings * height)
	TBHelperNamesString:SetText(names)
	TBHelperValuesString:SetText(values)
	
end

function TBShow(spellId)

	local _,_,offset,num = GetSpellTabInfo(2)
    for index = offset+1, offset+num, 1 do
		local Type,baseId = GetSpellBookItemInfo(index, "spell")
		local link = GetSpellLink(index, "spell")
		if link then
			realId = tonumber(link:match("spell:(%d+)"))
		else
			realId = nil
		end
		
		if realId == spellId or baseId == spellId then
			local name = GetSpellInfo(realId)
			print("realId = ", realId," name = ",name )
			name = GetSpellInfo(baseId)
			print("baseId = ", baseId," name = ",name )
			print("spellId = ", spellId)
		end
    end
end