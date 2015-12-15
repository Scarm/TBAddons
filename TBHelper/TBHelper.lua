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
		elseif value == false then
			return "false"
		else 
			return "???"
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

function TestItemLink()
	TBHelperTrash = {}
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link then
				local name = GetItemInfo(link)
				local key = tonumber(link:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:%d+:(%d+)"))
				
				if key ~= 0 then
					print(name, key)
				end
				
				TBHelperTrash[name] = link
				--TBHelperTrash[name.."-"] = select(2,GetItemInfo(GetContainerItemID(bag, slot)))
			end
		end
	end
	--/script print(GetItemInfo(129882))
	--	["Первобытный дух"] =       "|cff1eff00|Hitem:120945:    0:0:0:0:0:0:0:100:104:  0: 0:0|h[Первобытный дух]|h|r",
	--["Дренорская пыль"] =         "|cffffffff|Hitem:109693:    0:0:0:0:0:0:0:100:104:  0: 0:0|h[Дренорская пыль]|h|r",
	--["Пелерина призванных душ+"] ="|cffa335ee|Hitem:124141: 5311:0:0:0:0:0:0:100:104:  0: 3:1:560|h[Пелерина призванных душ]|h|r",
	--["Кольцо непобедимости+"] =   "|cff0070dd|Hitem:129874:    0:0:0:0:0:0:0:100:104:512:22:1:692:100|h[Кольцо непобедимости]|h|r",
	--["Оберег пробудителя+"] =     "|cff0070dd|Hitem:129882:    0:0:0:0:0:0:0:100:104:512:22:1:692:100|h[Оберег пробудителя]|h|r",
	--["Поножи крушащего удара+"] = "|cffa335ee|Hitem:113989:    0:0:0:0:0:0:0:100:104:  0: 5:1:566|h[Поножи крушащего удара]|h|r",
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

