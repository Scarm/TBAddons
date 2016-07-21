AdvancedPanelFrame.buttonsCount = 8

function UpdateHotkey(button)
	local key = GetBindingKey("CLICK "..button:GetName()..":LeftButton");
	if (key) then
		button.hotkey:SetText(key);
		button.hotkey:Show();
	else
		button.hotkey:SetText(key);
		button.hotkey:Hide();
	end
end

function AdvancedPanelFrame:Init()
	print("AdvancedPanelFrame:Init()")
	lastFrame = self	
	self.Buttons = {}
	
	BINDING_HEADER_TBBASE = "Режимы бота"
	
	for i = 1, self.buttonsCount do
		local button = CreateFrame("CheckButton","TBAdvancedButton"..i,IndicatorFrame,"TBAdvancedButtonTemplate")
		self.Buttons[i] = button
		
		local offset = 5
		
		button:SetPoint("LEFT", lastFrame,"RIGHT", offset, 0)
		button.hotkey = _G[button:GetName().."HotKey"];
		--button.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
		--button.cooldown:SetSwipeColor(0, 0, 0);
		TBSubscribeEvent(button,"UPDATE_BINDINGS", "UpdateHotkey")
		lastFrame = button
		
		setglobal("BINDING_NAME_CLICK TBAdvancedButton"..i..":LeftButton", "Режим "..i)
		UpdateHotkey(button)
	end	
end

function TBAdvancedButtonTemplate_OnSpellCast(self,event,unitID,spell,rank,lineID,spellID)
	if self.controller then
		self.controller:OnSpellCast(self,event,unitID,spell,rank,lineID,spellID)
	end
end

function TBAdvancedButtonTemplate_OnUpdateCooldown(self)
	if self.controller then
		self.controller:OnUpdateCooldown(self)
	end
end

function TBAdvancedButtonTemplate_OnClick(self, button)
	if self.controller then
		self.controller:OnClick(self, button)
	end
end

-- Базовый класс контроллера
Controller = {}
function Controller:OnClick(self, button)
	print("Controller:OnClick()")
end
function Controller:OnUpdateCooldown(self)
	print("Controller:OnUpdateCooldown()")
end
function Controller:OnSpellCast(self,event,unitID,spell,rank,lineID,spellID)
	print("Controller:OnSpellCast()")
end
function Controller:Assign(button)
	button.controller = self
	self.button = button
	button:Show()
end

-- Контроллер для триггеров
TriggerController = {}
setmetatable(TriggerController, {__index = Controller})
function TriggerController:OnClick(button, key)
	if self.checked then
		self.checked = nil
	else
		self.checked = 1
	end
	button:SetChecked(self.checked == 1)
end
function TriggerController:OnUpdateCooldown(button) end
function TriggerController:OnSpellCast(button,event,unitID,spell,rank,lineID,spellID) end

function TriggerController:Create(info)
	if info.Type == "trigger" then
		setmetatable(info, {__index = TriggerController})
		return info
	end
end
function TriggerController:Assign(button)
	button.controller = self
	button:Show()
	button.icon:SetTexture(self.Icon)
	button.AutoCastable:Hide()
	button:RegisterForClicks("LeftButtonUp")
end








--[[

function AdvancedPanelFrame:SpellCast(event,unitID,spell,rank,lineID,spellID)
	if lineID ~= 0 then	
		if AdvancedPanelFrame.Manual[spellID] then
			AdvancedPanelFrame.Manual[spellID]:SetChecked(false)
			AdvancedPanelFrame.Manual[spellID] = nil
		end
	end
end

function AdvancedPanelFrame:UpdateCooldown()
	for idx = 1, self.buttonsCount do
		button = self.Buttons[idx]
		if button.Type == "spell" then
			local start, duration, enable = GetSpellCooldown(button.Spell);
			CooldownFrame_SetTimer(button.cooldown, start, duration, enable);
		end
	end
end

AdvancedPanelFrame.Types = {}
AdvancedPanelFrame.Types["trigger"] = {}
AdvancedPanelFrame.Types["trigger"].Handler = function(self)
	if self:GetChecked() then
		AdvancedPanelFrame.Groups[self.Name] = self
	else
		AdvancedPanelFrame.Groups[self.Name] = nil
	end
	print("trigger handler", self.Name, AdvancedPanelFrame.Groups[self.Name])
end
AdvancedPanelFrame.Types["trigger"].Setter = function(self, button)
	self:Show()
	self.icon:SetTexture(button.Icon)
	self.AutoCastable:Hide()
	self.Name = button.Name
	self:RegisterForClicks("LeftButtonUp")
end

AdvancedPanelFrame.Types["spell"] = {}
AdvancedPanelFrame.Types["spell"].Handler = function(self, button)
	if button == "RightButton" then
		
		if AdvancedPanelFrame.Auto[self.Spell] then
			AdvancedPanelFrame.Auto[self.Spell] = nil
			AutoCastShine_AutoCastStop(self.Shine)
		else
			AdvancedPanelFrame.Auto[self.Spell] = self
			AutoCastShine_AutoCastStart(self.Shine)
		end
		
		self:SetChecked(self:GetChecked() == nil )
	else
		
		if AdvancedPanelFrame.Manual[self.Spell] then
			AdvancedPanelFrame.Manual[self.Spell] = nil
			self:SetChecked(false)
		else
			AdvancedPanelFrame.Manual[self.Spell] = self
			self:SetChecked(true)
		end
		
	end	
end
AdvancedPanelFrame.Types["spell"].Setter = function(self, button)
	self:Show()
	self.icon:SetTexture(GetSpellTexture(button.Spell))
	self.AutoCastable:Show()
	self.Spell = button.Spell
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end
--]]

function AdvancedPanelFrame:AssignSpec(spec)
	self.Groups = {}
	
	
	for idx = 1, self.buttonsCount do
		button = self.Buttons[idx]
		button:Hide()
		button.Controller = nil
	end
	
	
	self.Auto = {}
	self.Manual = {}
	
	if spec and spec.advanced then
		self:Show()
		for idx, value in pairs(spec.Buttons or {}) do
			
			if idx <= self.buttonsCount then
				button = self.Buttons[idx]
							
				local controller = TriggerController:Create(value) or Controller
				
				controller:Assign(button)
				
				--button:Show()
			else
				print("Не понятный тип кнопки:", value.Type or "nil")
			end			
			--[[
			if value.Type and self.Types[value.Type] and idx <= self.buttonsCount then
				button = self.Buttons[idx]
				self.Types[value.Type].Setter(button, value)
				button:SetScript("OnClick", self.Types[value.Type].Handler)
				button.Type = value.Type
			else
				print("Не понятный тип кнопки:", value.Type or "nil")
			end
			--]]
		end	
	else
		self:Hide()
	end
	
end