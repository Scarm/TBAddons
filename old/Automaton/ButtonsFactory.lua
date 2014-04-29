print("ButtonsFactory.lua")

--[[
ButtonsFactory = {}

function ButtonsFactory:ToggleButton( modes )
    local button = {}
    button.Modes = {}
    button.ModeCount = 0
    button.Idx = 0

    for name,icon in pairs( modes ) do
        button.Modes[button.ModeCount] = {}
        button.Modes[button.ModeCount].Name = name
        button.Modes[button.ModeCount].Icon = icon

        button.ModeCount = button.ModeCount + 1                
    end

    function button:OnClick(button)        
        if button == "LeftButton" then
            self.Idx = self.Idx + 1
            if self.Idx == self.ModeCount then
                self.Idx = 0
            end
        else
            self.Idx = self.Idx - 1
            if self.Idx < 0 then
                self.Idx = self.ModeCount - 1
            end
        end
        self:Update()
    end

    function button:Update()
        self.Mode = self.Modes[self.Idx].Name
        self.Icon = self.Modes[self.Idx].Icon
    end

    button:Update()
    return button
end

function ButtonsFactory:SpellButton( spellID, target )
    local button = {}
    button.SpellID = spellID
    button.Target = target
    button.Cooldown = {}
    _,_,button.Icon = GetSpellInfo(spellID)
    
    function button:OnCooldownChange()       
        self.Cooldown.Start,self.Cooldown.Duration,self.Cooldown.Enabled = GetSpellCooldown(self.SpellID)
    end

    function button:OnClick(button)
        Automaton:PushSpell(self.SpellID, self.target)
    end

    return button
end

--]]
-- вариант с наследованием

BaseButton = {
    Icon = "Interface\\Icons\\Ability_Warrior_RallyingCry",
    Enabled = 1
}

function BaseButton:GetIcon()
    return self.Icon
end

function BaseButton:GetCooldown()
    return self.CooldownStart, self.CooldownDration
end

function BaseButton:GetEnabled()
    return self.Enabled
end

function BaseButton:GetChecked()
    return self.Checked
end

function BaseButton:OnEvent(event,...)
  
end


ToggleButton = {}
setmetatable(ToggleButton, {__index = BaseButton})

function ToggleButton:Create(modes)
    local button = {}
    setmetatable(button, {__index = self})
    
    button.Modes = {}
    button.ModeCount = 0
    button.Idx = 0
    
    for name,icon in pairs(modes) do
        button.Modes[button.ModeCount] = {}
        button.Modes[button.ModeCount].Name = name
        button.Modes[button.ModeCount].Icon = icon

        button.ModeCount = button.ModeCount + 1                
    end
    button:Update()
    return button
end

function ToggleButton:OnClick(button)        
    if button == "LeftButton" then
	self.Idx = self.Idx + 1
	if self.Idx == self.ModeCount then
	    self.Idx = 0
	end
    else
	self.Idx = self.Idx - 1
	if self.Idx < 0 then
	    self.Idx = self.ModeCount - 1
	end
    end
    self:Update()
end

function ToggleButton:Update()
    self.Mode = self.Modes[self.Idx].Name
    self.Icon = self.Modes[self.Idx].Icon
end



SpellButton = {}
setmetatable(SpellButton, {__index = BaseButton})

function SpellButton:Create( spellID, target )
    local button = {}
    setmetatable(button, {__index = self})
    
    button.SpellID = spellID
    button.Target = target
    _,_,button.Icon = GetSpellInfo(spellID)
    button.EventHandler = EventHandler:Create(button, 
        {
            ["SPELL_UPDATE_COOLDOWN"] = "OnCooldown",
            ["UNIT_SPELLCAST_START"] = "OnSpellcast",
            ["UNIT_SPELLCAST_SUCCEEDED"] = "OnSpellcast",
        })

    return button
end

function SpellButton:OnEvent(event,...)       
    self.EventHandler:OnEvent(event,...) 
end

function SpellButton:OnCooldown(...)
   self.CooldownStart, self.CooldownDration = GetSpellCooldown(self.SpellID) 
end

function SpellButton:OnSpellcast()
   if Automaton:GetSpell(self.SpellID) then
       self.Checked = 1
   else
       self.Checked = nil
   end
end

function SpellButton:OnClick(button) 
    if self.Checked then
        print("CancelSpell")
        Automaton:CancelSpell(self.SpellID)
        self.Checked = nil
    else
        print("PushSpell")
        Automaton:PushSpell(self.SpellID, self.Target)
        self.Checked = 1
    end
end


