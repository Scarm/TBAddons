SLASH_TBHELPER1 = '/tbh';
function SlashCmdList.TBHELPER(msg, editbox)
    if msg == 'hide' then
		TBHelperFrame:Hide()
		TBHelperValuesFrame:Hide()
	end
	
	if msg == 'show' then
		TBHelperFrame:Show()
		TBHelperValuesFrame:Show()
	end
	
	if msg == 'names' then
		TBGroupNames()
	end
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
	print("TBHelperOnPlayerLogin")
	if TBHelperData == nil then
		TBHelperData = {}						
	end
	
	local _,class = UnitClass("player")
	
	TBHelperData.Followers = {}-- C_Garrison.GetFollowers()
	
	if TBHelperGlyphs == nil then
		TBHelperGlyphs = {}
	end
	TBHelperGlyphs[class] = {}
	
	for i = 1,GetNumGlyphs(),1 do
		local name, glyphType, isKnown, icon, castSpell = GetGlyphInfo(i)
		if isKnown == false and glyphType == 1 then
			TBHelperGlyphs[class][name] = glyphType
		end
	end
	
	
	if TBHelperAuras == nil then
		TBHelperAuras = {}
	end
	
	if TBHelperData.Specializations == nil then
		TBHelperData.Specializations = {}		
	end	
	
		

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
		TBHelperSpellFrame.SpellsString = TBHelperSpellFrameList
		TBLists(TBHelperSpellFrame)
	end	
end

function ToString(value)
	if value == nil then
		return "nil"
	end
	
	if type(value) == "boolean" then
		if value == true then
			return "true"
		else
			return "false"
		end
	end
	
	if type(value) == "function" then
		return "function"
	end
	
	if type(value) == "table" then
		return "table"
	end	
	
	return value
end

function TBFillValues(values)

	values["1"] = 1
	
	local gr = TBGroups()
	
	values["LastCommand"] = IndicatorFrame.LastCommand
	
	values["LastCastTarget"] = IndicatorFrame.LastTarget
	
	values["UnitAffectingCombat"] = ToString(UnitAffectingCombat("target"))
	
	values["focusname"] = ToString(GetUnitName("focus"))
	
	values["UnitThreatSituation"] = ToString(UnitThreatSituation("player","target"))
	
	--values["Burst"] = PanelFrame.Groups.Burst or "nil"

	--local hasDebuff = gr.party:HasBossDebuff()
	--for k,v in pairs(hasDebuff) do
	--	values[k] = UnitName(k)	
	--end
	
	
	--Interface\\ICONS\\Spell_ChargeNegative.blp
	--Interface\\ICONS\\Spell_ChargePositive.blp
	
	--[[
	if UnitAura("player","Ясность воли") then
		local v1 = select(1,UnitAura("player","Ясность воли"))
		values["param1"] = ToString(v1)
		
		local v1 = select(11,UnitAura("player","Ясность воли"))
		values["param11"] = ToString(v1)
		
		for i = 14,20,1 do
			local v1 = select(i,UnitAura("player","Ясность воли"))
			values["param"..i] = ToString(v1)
		end
	end
	--]]
	
	--values["boss1"] = ToString(UnitName("boss1"))
	--values["Velari"] = ToString(select(15, UnitAura("boss1", "Аура презрения")))
	

	--[[
	for k,v in pairs(gr.tanks) do
		values[k] = UnitName(k)
	end
	--]]
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

function TBHelperLogDebuffs()
	local targets = TBGroups().targets
	
	local zone = GetZoneText()
	local subzone = GetSubZoneText()
	
	if TBHelperAuras[zone] == nil then
		TBHelperAuras[zone] = {}
	end
	if TBHelperAuras[zone][subzone] == nil then
		TBHelperAuras[zone][subzone] = {}
	end	
	
	local zn = TBHelperAuras[zone][subzone]
	
	if zn.buffs == nil then
		zn.buffs = {}
	end
	if zn.debuffs == nil then
		zn.debuffs = {}
	end	
	
	
	for key,value in pairs(targets) do

		for i=1,40,1 do
			local name = UnitAura(key,i)
			local id = select(11, UnitAura(key,i))
			
			if name then
				zn.buffs[id] = name
			end
		end
		
		for i=1,40,1 do
			local name = UnitAura(key,i,"HARMFUL")
			local id = select(11, UnitAura(key,i,"HARMFUL"))
			
			if name then
				zn.debuffs[id] = name
			end
		end	
	
	end
	
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
	
	
	TBHelperNamesString:SetText(names)
	TBHelperValuesString:SetText(values)
	
	TBHelperValuesFrame:SetHeight(strings * height)
	TBHelperValuesFrame:SetWidth( TBHelperNamesString:GetStringWidth() + TBHelperValuesString:GetStringWidth()+10)
	TBHelperNamesString:SetWidth(TBHelperNamesString:GetStringWidth())
	TBHelperValuesString:SetWidth(TBHelperValuesString:GetStringWidth())
	
	
	TBHelperLogDebuffs()
end


function TBFollowers()
		
		Equip = {		
			["Слабое улучшение оружия"] = {
				Type = "weapon",
				Value = 3,
				Amount = 0,
			},
			["Среднее улучшение оружия"] = {
				Type = "weapon",
				Value = 6,
				Amount = 0,
			},
			["Усиленное улучшение оружия"] = {
				Type = "weapon",
				Value = 9,
				Amount = 0,
			},
			
			["Слабое улучшение брони"] = {
				Type = "armor",
				Value = 3,
				Amount = 0,
			},
			["Среднее улучшение брони"] = {
				Type = "armor",
				Value = 6,
				Amount = 0,
			},
			["Усиленное улучшение брони"] = {
				Type = "armor",
				Value = 9,
				Amount = 0,
			},
			
		}
		

	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			local id = GetContainerItemID(bag, slot)
			if id then
				local name = GetItemInfo(id)
				local _,count = GetContainerItemInfo(bag, slot)
				
				for k,v in pairs(Equip) do
					if name == k then
						v.Amount = v.Amount + count
					end
				end
			end
		end
	end
	
	local totalWeapon = 0
	local totalArmor = 0
	
	for k,v in pairs(Equip) do
		--print(k, v.Amount)
		if v.Type == "weapon" then
			totalWeapon = totalWeapon + v.Amount * v.Value
		end
		
		if v.Type == "armor" then
			totalArmor = totalArmor + v.Amount * v.Value
		end
	end
	
	local followersCount = 0
	local requiredWeapon = - totalWeapon
	local requiredArmor = - totalArmor
	local followers = C_Garrison.GetFollowers()
	for k,follower in pairs(followers) do
		if follower.isCollected == true then
			local weaponItemID, weaponItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(follower.followerID)
			requiredWeapon = requiredWeapon + 675 - weaponItemLevel
			requiredArmor = requiredArmor + 675 - armorItemLevel
		end
	end
	print("required weapon upgrades", requiredWeapon)
	print("required armor upgrades", requiredArmor)
end

function TBInitDebuffs()
	if TBHelperDebuffIgnores == nil then
		TBHelperDebuffIgnores = {}
	end
	
	if TBHelperDebuffQueue == nil then
		TBHelperDebuffQueue = {}
	end
	
	TBAddDebuffButton:Hide()
	TBInfoDebuffButton:Hide()
	TBIgnoreDebuffButton:Hide()
end

TBCurrentDebuff = nil

function SetDebuffButton()
	if TBCurrentDebuff == nil then
		for id,name in pairs(TBHelperDebuffQueue) do 
			TBAddDebuffButton.icon:SetTexture("Interface\\ICONS\\Spell_ChargePositive.blp")		
			TBIgnoreDebuffButton.icon:SetTexture("Interface\\ICONS\\Spell_ChargeNegative.blp")			
			local _,_,icon = GetSpellInfo(id)
			TBInfoDebuffButton.icon:SetTexture(icon)
			
			TBAddDebuffButton:Show()
			TBInfoDebuffButton:Show()
			TBIgnoreDebuffButton:Show()
			
			TBCurrentDebuff = id
		end	
	end
end

function TBAddDebuff()
	if TBCurrentDebuff then
		TBDebuffList[TBCurrentDebuff] = TBHelperDebuffQueue[TBCurrentDebuff]
		TBHelperDebuffQueue[TBCurrentDebuff] = nil
		
		TBAddDebuffButton:Hide()
		TBInfoDebuffButton:Hide()
		TBIgnoreDebuffButton:Hide()
		TBCurrentDebuff = nil
		
		SetDebuffButton()
	end
end

function TBInfoDebuff()
	if TBCurrentDebuff then
		local name = UnitAura(TBCurrentDebuff)
		print(name.." ("..TBCurrentDebuff..")")
	end
end

function TBIgnoreDebuff()
	if TBCurrentDebuff then
		TBHelperDebuffIgnores[TBCurrentDebuff] = TBHelperDebuffQueue[TBCurrentDebuff]
		TBHelperDebuffQueue[TBCurrentDebuff] = nil
		
		TBAddDebuffButton:Hide()
		TBInfoDebuffButton:Hide()
		TBIgnoreDebuffButton:Hide()
		TBCurrentDebuff = nil
		
		SetDebuffButton()
	end
end

function TBTupleToMap(...)
	local result = {}
	local sz = select("#", ...)
	for i = 1, sz, 1 do
		result["val"..i] = select(i, ...)
	end
	return result
end

function TBScanDebuffs()
	if UnitName("boss1") and IsInRaid() then -- Нас пока интересуют только спеллы босса
		local party = TBGroups().party
		
		for k,v in pairs(party) do 
			if UnitCanAssist("player", k) then	-- // Сюда может попасть mouseover, надо его отбросить
				for i=1,40,1 do
					local t = "HARMFUL"
					local name = UnitAura(k,i,t)
					local id = select(11, UnitAura(k,i,t))
					if id and TBHelperDebuffQueue[id] == nil and TBHelperDebuffIgnores[id] == nil and TBDebuffList[id] == nil then
						TBHelperDebuffQueue[id] = name
					end
				end			
			end
		end
		
		TBHelperDebuffCollection = TBHelperDebuffCollection or {}
		TBHelperDebuffCollection[UnitName("boss1")] = TBHelperDebuffCollection[UnitName("boss1")] or {}
		local bossDebuffs = TBHelperDebuffCollection[UnitName("boss1")]
		
		for k,v in pairs(party) do 
			if UnitCanAssist("player", k) then	-- // Сюда может попасть mouseover, надо его отбросить
				for i=1,40,1 do
					local id = select(11, UnitAura(k,i,"HARMFUL"))
					if id and bossDebuffs[id] == nil then
						bossDebuffs[id] = TBTupleToMap(UnitAura(k,i,"HARMFUL"))
						print("debuff logged: ", id)
					end
				end
			end
		end
		
		local targets = TBGroups().targets
		TBHelperTargetsCollection = TBHelperTargetsCollection or {}
		TBHelperTargetsCollection[UnitName("boss1")] = TBHelperTargetsCollection[UnitName("boss1")] or {}
		local bossTargets = TBHelperTargetsCollection[UnitName("boss1")]
		
		for k,v in pairs(targets) do
			if UnitCanAttack("player", k) then
				local name = UnitName(k)
				if name and bossTargets[name] == nil then
					bossTargets[name] = 1
				end
			end		
		end
	end	
	SetDebuffButton()
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