AdvancedPanelFrame.buttonsCount = 12

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
	lastFrame = self
	self.Buttons = {}

	BINDING_HEADER_TBBASE = "Режимы бота"

	for i = 1, self.buttonsCount do
		local button = CreateFrame("CheckButton","TBAdvancedButton"..i,IndicatorFrame,"TBAdvancedButtonTemplate")
		self.Buttons[i] = button

		local offset = 5

		button:SetPoint("LEFT", lastFrame,"RIGHT", offset, 0)
		button.hotkey = _G[button:GetName().."HotKey"];
		button.cooldown:SetSwipeColor(0, 0, 0)
		TBSubscribeEvent(button,"UPDATE_BINDINGS", "UpdateHotkey")
		lastFrame = button

		setglobal("BINDING_NAME_CLICK TBAdvancedButton"..i..":LeftButton", "Режим "..i)
		UpdateHotkey(button)
	end
end

function TBAdvancedButtonTemplate_OnSpellCast(self,...)
	if self.controller then
		self.controller:OnSpellCast(self,...)
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
function Controller:State(data) -- заполнить информацию о себе
	print("Controller:State()")
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
function TriggerController:OnSpellCast(button,event,unit,spell,xxx,lineID,spellID) end

function TriggerController:State(data) -- заполнить информацию о себе
	data.toggle = data.toggle or {}
	data.toggle[self.Name] = self.checked
end

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

-- Контроллер для мультирежимных кнопок
SelectorController = {}
setmetatable(SelectorController, {__index = Controller})
function SelectorController:OnClick(button, key)
	self:NextState()
	button.icon:SetTexture(self.icon)
	button:SetChecked(false)
end
function SelectorController:OnUpdateCooldown(button) end
function SelectorController:OnSpellCast(button,event,unit,spell,xxx,lineID,spellID) end

function SelectorController:State(data) -- заполнить информацию о себе
	data.selector = data.selector or {}
	data.selector[self.Name] = self.value
end

function SelectorController:Create(info)
	if info.Type == "selector" then
		setmetatable(info, {__index = SelectorController})
		return info
	end
end

function SelectorController:Assign(button)
	button.controller = self
	button:Show()
	self:NextState()
	button.icon:SetTexture(self.icon)
	button.AutoCastable:Hide()
	button:RegisterForClicks("LeftButtonUp")
end

function SelectorController:NextState()
	--print("idx", self.idx)
	--self.idx = self.idx or -1
	--self.idx = (self.idx + 1) % (#self.Values)

	if self.idx then
		self.idx = (self.idx + 1) % (#self.Values)
	else
		--print("first init")
		self.idx = 0
		while self.Values[self.idx+1] and not self.Values[self.idx+1].default do
			--print("skip",self.idx)
			self.idx = self.idx + 1
		end
		self.idx = self.idx % (#self.Values)
	end

	--print("idx_", self.idx)
	self.value = self.Values[self.idx+1].Value
	--print("value", self.value)
	self.icon =  self.Values[self.idx+1].Icon
	--print("icon", self.icon)
end

-- Контроллер для спелов
SpellController = {}
setmetatable(SpellController, {__index = Controller})
function SpellController:OnClick(button, key)
	if key == "LeftButton" then
		if self.checked then
			self.checked = nil
		else
			self.checked = 1
		end
	end

	if key == "RightButton" then
		if self.auto then
			self.auto = nil
			AutoCastShine_AutoCastStop(button.Shine)
		else
			self.auto = 1
			AutoCastShine_AutoCastStart(button.Shine)
		end
	end

	button:SetChecked(self.checked == 1)
end
function SpellController:OnUpdateCooldown(button)
	local start, duration, enable = GetSpellCooldown(self.Spell)
	CooldownFrame_Set(button.cooldown, start, duration, enable)
end
function SpellController:OnSpellCast(button,event,caster, spellUid, spellID)
	if spellID == self.Spell then
		self.checked = nil
		button:SetChecked(self.checked == 1)
	end
end

function SpellController:State(data) -- заполнить информацию о себе
	data.auto = data.auto or {}
	data.manual = data.manual or {}
	data.auto[self.Spell] = self.auto
	data.manual[self.Spell] = self.checked
end

function SpellController:Create(info)
	if info.Type == "spell" then

		if info.talent then
			local enabled = select(4,GetTalentInfoByID(info.talent,1))
			if enabled then
				setmetatable(info, {__index = SpellController})
				return info
			end
		elseif info.no_talent then
			local enabled = select(4,GetTalentInfoByID(info.no_talent,1))
			if not enabled then
				setmetatable(info, {__index = SpellController})
				return info
			end
		else
			setmetatable(info, {__index = SpellController})
			return info
		end
	end
end
function SpellController:Assign(button)
	button.controller = self
	button:Show()
	button.icon:SetTexture(GetSpellTexture(self.Spell))
	button.AutoCastable:Show()
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	local start, duration, enable = GetSpellCooldown(self.Spell)
	CooldownFrame_Set(button.cooldown, start, duration, enable)
end

function AdvancedPanelFrame:AssignSpec(spec)
	for idx = 1, self.buttonsCount do
		button = self.Buttons[idx]
		button:Hide()
		button.Controller = nil
	end

	if spec then
		self:Show()

		local idx = 1
		local pos = 1
		local buttons = spec.Buttons or {}
		while buttons[idx] do

			if idx <= self.buttonsCount then
				button = self.Buttons[pos]
				local value = buttons[idx]
				local controller = TriggerController:Create(value) or SpellController:Create(value) or SelectorController:Create(value)
				if controller then
					controller:Assign(button)
					pos = pos + 1
				end
			else
				print("Слишком много кнопок!")
			end

			idx = idx + 1
		end

	else
		self:Hide()
	end
end

function AdvancedPanelFrame:Modes()
	local result = {}
	result.auto = {}
	result.manual = {}

	for i = 1, self.buttonsCount do
		local button = self.Buttons[i]
		if button.controller then
			button.controller:State(result)
		end
	end
	return result
end
