function TBUtilsAdd(frame, icon, name)
	TBHelperUtils.lastFrame = TBHelperUtils.lastFrame or TBHelperUtils
	TBHelperUtils.buttonsCount = TBHelperUtils.buttonsCount or 0
	
	TBHelperUtils.buttonsCount = TBHelperUtils.buttonsCount + 1
	local button = CreateFrame("CheckButton","TBHelperUtilButton"..TBHelperUtils.buttonsCount,TBHelperUtils,"TBHelperUtilButtonTemplate")
	button:SetPoint("LEFT", TBHelperUtils.lastFrame,"RIGHT", 4, 0)
	button.icon:SetTexture(icon)
	button.frame = frame
	if name then
		local text = _G[button:GetName().."Count"];
		text:SetText(name);
	end
	frame:Hide()
	
	TBHelperUtils.lastFrame.next = button
	TBHelperUtils.lastFrame = button

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

function TBPrintEvent(self,event,...)
	print(event,...)
end

-- Сюда временно сложена информация по глифам
function CollectGlyphInfo()
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

TBTmp = {}



