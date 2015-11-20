function TBShowItemsFrame()
	TBItemsFrame:Show()
end

function TBHideItemsFrame()
	TBItemsFrame:Hide()
end

function TBSetCurrentItem()
	local type_, data, subType, subData = GetCursorInfo()
	
	if type_ == "item" then
		TBSelectedItem.link = subType
		TBSelectedItem.itemID = data
		TBSelectedItem.icon:SetTexture(GetItemIcon(data))
		TBReceiverSelection:Show()
		TBSenderSelection:Show()
	end
	
	ClearCursor() 
end

function TBClearCurrentItem()
	TBSelectedItem.link = nil
	TBSelectedItem.itemID = nil
	TBSelectedItem.icon:SetTexture(nil)
	TBReceiverSelection:Hide()
	TBSenderSelection:Hide()
end

function TBItemRulesUpdateList()

	local _,height = TBItemRulesList:GetFont()
	local text = ""
	local strings = 0
	for id,value in pairs(TBItemRules.Rules) do
		if text~="" then
			text = text.."\n"
		end
		local t = (value.link).."["..value.sender .. ">".. value.receiver.."]"
		text = text..t
		strings = strings + 1
		--print(t)
	end
		
	TBItemRulesList:SetHeight(strings * height)
	TBItemRulesList:SetText(text)
end

function TBRemoveCurrentItem()
	
	if TBSelectedItem.itemID then
		TBItemRules.Rules[TBSelectedItem.itemID] = nil
		TBItemRulesUpdateList()
		TBClearCurrentItem()
	end
end

function TBAddCurrentItem()
	TBItemRules = TBItemRules or {}
	TBItemRules.Rules = TBItemRules.Rules or {}
	
	if TBSelectedItem.itemID and TBSelectedItem.sender and TBSelectedItem.receiver then
		TBItemRules.Rules[TBSelectedItem.itemID] = {}
		TBItemRules.Rules[TBSelectedItem.itemID].sender = TBSelectedItem.sender
		TBItemRules.Rules[TBSelectedItem.itemID].receiver = TBSelectedItem.receiver
		TBItemRules.Rules[TBSelectedItem.itemID].link = TBSelectedItem.link
		
		TBItemRulesUpdateList()
		TBClearCurrentItem()
	end
end

function TBInitMailDropDowns()
	TBItemRules = TBItemRules or {}
	TBItemRules.Units = TBItemRules.Units or {}
	local name = UnitName("player")
	TBItemRules.Units[name] = TBItemRules.Units[name] or {}
	
	local function OnSenderClick(self)
	   UIDropDownMenu_SetSelectedName(TBSenderSelection, self:GetText())
	   TBSelectedItem.sender = self:GetText()
	end
	
	local function initSenderSelection(self, level)
		info = UIDropDownMenu_CreateInfo()
		info.text = name
		info.value = name
		info.func = OnSenderClick
		UIDropDownMenu_AddButton(info, level)
				
		info = UIDropDownMenu_CreateInfo()
		info.text = "All"
		info.value = "All"
		info.func = OnSenderClick
		UIDropDownMenu_AddButton(info, level)
	end
	
	UIDropDownMenu_Initialize(TBSenderSelection, initSenderSelection)
	UIDropDownMenu_SetWidth(TBSenderSelection, 150)
	UIDropDownMenu_SetButtonWidth(TBSenderSelection, 50)
	UIDropDownMenu_JustifyText(TBSenderSelection, "LEFT")
	UIDropDownMenu_SetSelectedName(TBSenderSelection, "All")
	TBSelectedItem.sender = "All"
	TBSenderSelection:Hide()
	
	local function OnReceiverClick(self)
	   UIDropDownMenu_SetSelectedName(TBReceiverSelection, self:GetText())
	   TBSelectedItem.receiver = self:GetText()
	end
	
	local function initReceiverSelection(self, level)

		for k,v in pairs(TBItemRules.Units) do
			if k ~= name then
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = k
				info.func = OnReceiverClick
				UIDropDownMenu_AddButton(info, level)
			end
		end	
	end
	
	UIDropDownMenu_Initialize(TBReceiverSelection, initReceiverSelection)
	UIDropDownMenu_SetWidth(TBReceiverSelection, 150)
	UIDropDownMenu_SetButtonWidth(TBReceiverSelection, 50)
	UIDropDownMenu_JustifyText(TBReceiverSelection, "LEFT")
	TBReceiverSelection:Hide()
	
	TBItemRulesUpdateList()
	TBItemsFrame:Hide()
end

function TBSendAllItems()
	print("TBSendAllItems")
	
	local idx = 1
	local receiver = nil
	
	for bag = 0,4 do
		local skip = true
		if (bag == 0) then
			skip = GetBackpackAutosortDisabled();
		else
			skip = GetBagSlotFlag(bag, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP);
		end
		
		if skip == false then
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				if id and TBItemRules.Rules[id] then
				
					local value = TBItemRules.Rules[id]
					local name = UnitName("player")
					
					receiver = receiver or value.receiver
					
					if (value.sender == name or value.sender == "All") and value.receiver == receiver then
						PickupContainerItem(bag, slot)
						ClickSendMailItemButton(idx, false)
						idx = idx + 1
					end
					
					if idx == 13 then
						SendMail(receiver, "Предметы","")
						return
					end
				end
			end
		end
	end

	if receiver then
		SendMail(receiver, "Предметы","")
	end
end














