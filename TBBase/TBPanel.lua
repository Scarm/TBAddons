
roleButtons = {
			["DAMAGER"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "AgroType"
					},
					[2] = {
						Icon = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
						ToolTip = "Solo",
						GroupId = "AgroType",
						default = 1
					},
					[3] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Charge",
						ToolTip = "Aggo",
						GroupId = "AgroType"
					},
					[4] = {
						Icon = "Interface\\Icons\\Ability_Stealth",
						ToolTip = "Care",
						GroupId = "AgroType"
					},
					
					[5] = {
						Icon = "Interface\\Icons\\Ability_MeleeDamage",
						ToolTip = "Single",
						GroupId = "Rotation",
						default = 1
					},
					[6] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
						ToolTip = "AoE",
						GroupId = "Rotation"
					},
					[7] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Rampage",
						ToolTip = "Burst",
						GroupId = "Rotation"
					},
				},
			["HEALER"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "Type"
					},
					[2] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierGreen.blp",
						ToolTip = "Low",
						GroupId = "Type",
						default = 1
					},
					[3] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierOrange.blp",
						ToolTip = "Medium",
						GroupId = "Type"
					},
					[4] = {
						Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
						ToolTip = "High",
						GroupId = "Type"
					},
				},
			["TANK"] = {
					[1] = {
						Icon = "Interface\\Icons\\ABILITY_SEAL",
						ToolTip = "Off",
						GroupId = "AgroType"
					},
					[2] = {
						Icon = "Interface\\Icons\\ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
						ToolTip = "Solo",
						GroupId = "AgroType",
						default = 1
					},
					[3] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Charge",
						ToolTip = "Aggo",
						GroupId = "AgroType"
					},
					[4] = {
						Icon = "Interface\\Icons\\Ability_Stealth",
						ToolTip = "Care",
						GroupId = "AgroType"
					},
					
					[5] = {
						Icon = "Interface\\Icons\\Ability_MeleeDamage",
						ToolTip = "Single",
						GroupId = "Rotation",
						default = 1
					},
					[6] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
						ToolTip = "AoE",
						GroupId = "Rotation"
					},
					[7] = {
						Icon = "Interface\\Icons\\Ability_Warrior_Rampage",
						ToolTip = "Burst",
						GroupId = "Rotation"
					},
				},
		}

function TBCreateButton(tail)
	button = CreateFrame("CheckButton","TBButton",IndicatorFrame,"TBButtonTemplate")
	button:SetPoint("LEFT", tail,"RIGHT", 5, 0)
	return button
end

function TBAddButton(context)

end


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
	
	local buttons = bot.Buttons or roleButtons[role]

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