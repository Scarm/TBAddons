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
	print("TBHelperOnPlayerLogin")
	if TBHelperData == nil then
		TBHelperData = {}						
	end
	
	TBHelperData.Followers = C_Garrison.GetFollowers()
	
	if TBHelperAuras == nil then
		TBHelperAuras = {}
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

function BoolToString(value)
	if value == nil then
		return "nil"
	end
	if value == true then
		return "true"
	end
	if value == false then
		return "false"
	end
end


function TBFillValues(values)

	values["1"] = 1
	
	local gr = TBGroups()
	values["DmgPerHealer"] = gr.DamagePerHealer
	
	values["LastCommand"] = IndicatorFrame.LastCommand
	

	for k,v in pairs(IndicatorFrame.LoS.Banned) do
		local lastBanned = v or 0
		if GetTime() < lastBanned + 2 then
			values[k] = v	
		end
	end

	values["target"] = GetUnitName("target",true)
	
	--[[
	if IndicatorFrame.LastSpell then
		values["lastcast"] = IndicatorFrame.LastSpell.Key
	else 
		values["lastcast"] = "nil"	
	end
	
	local key = "Слово Тьмы: Смерть"
	local cond = IndicatorFrame.LastSpell and IndicatorFrame.LastSpell.Key == key
	
	values["cond"] = cond or "nil"	
	--]]
	

	--[[
	for i=1,40,1 do
		local name = UnitAura("player",i)
		local id = select(11, UnitAura("player",i))
		
		if name then
			values["+"..id] = name
		end
	end
	
	for i=1,40,1 do
		local name = UnitAura("target",i,"HARMFUL")
		local id = select(11, UnitAura("target",i,"HARMFUL"))
		
		if name then
			values["-"..id] = name
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
	
	TBHelperValuesFrame:SetHeight(strings * height)
	TBHelperNamesString:SetText(names)
	TBHelperValuesString:SetText(values)
	
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