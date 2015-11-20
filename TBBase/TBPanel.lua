function TBCreatePanel()
	print("Create panel")
	lastFrame = PanelFrame	
	PanelFrame.Buttons = {}
	
	BINDING_HEADER_TBBASE = "Режимы бота"
	
	for i = 1,8 do
		local button = CreateFrame("CheckButton","TBButton"..i,IndicatorFrame,"TBButtonTemplate")
		PanelFrame.Buttons[i] = button
		
		local offset = 5
		
		button:SetPoint("LEFT", lastFrame,"RIGHT", offset, 0)
		button.hotkey = _G[button:GetName().."HotKey"];
		TBSubscribeEvent(button,"UPDATE_BINDINGS", "TBUpdateBindings")
		lastFrame = button
		
		setglobal("BINDING_NAME_CLICK TBButton"..i..":LeftButton", "режим "..i)
		TBUpdateBindings(button)
	end	
end

function TBUpdateBindings(button)
	local key = GetBindingKey("CLICK "..button:GetName()..":LeftButton");
	--print(key)
	
	if (key ) then
        button.hotkey:SetText(key);
        button.hotkey:Show();
    else
        button.hotkey:SetText(key);
        button.hotkey:Hide();
    end
end

function TBGroupControl(self)

	local any = 0
	for idx = 1,8 do
		button = PanelFrame.Buttons[idx]
		if button.GroupId == self.GroupId and button~=self then
			button:SetChecked(false)
			any = any + 1
		end
	end
	
	if any > 0 then
		self:SetChecked(true)
		PanelFrame.Groups[self.GroupId] = self.GroupValue
	else
	if self:GetChecked() then
		PanelFrame.Groups[self.GroupId] = self.GroupValue	
	else
		PanelFrame.Groups[self.GroupId] = nil	
	end		
	end

end

function TBClearPanel()
	PanelFrame.Groups = {}
	
	for idx = 1,8 do
		button = PanelFrame.Buttons[idx]
		button:Hide()
	end
end

function TBInitPanel(bot)
	--print()
	local role = select(6,GetSpecializationInfo(GetSpecialization()))
	--print(role)
	
	local buttons = bot.Buttons

	if (buttons) then
		for idx, value in pairs(buttons) do
			button = PanelFrame.Buttons[idx]
			button:Show()
			button.icon:SetTexture(value.Icon)
			button.GroupId = value.GroupId
			button.GroupValue = value.ToolTip
			button:SetScript("OnClick", TBGroupControl)
			if value.default then
				button:SetChecked(true)
				TBGroupControl(button)
			end
		end	
	end
end