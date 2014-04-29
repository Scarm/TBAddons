AutomatonPanel = {}
Automaton.Panel = AutomatonPanel
function AutomatonPanel:OnLoad(frame)
	self.Frame = frame
    print("AutomatonPanel:OnLoad")
    self.Buttons = {}
    self.ButtonCount = 0
    for i=0,4,1 do
        btn = CreateFrame("CheckButton","AutomatonButton"..i,self.Frame,"ModeButtonTemplate")
        btn:SetPoint("TOPLEFT", 17 + 40 * i , -17 )
        self:ResetButton(btn)  
        self.Buttons[i] = btn 
    end  
end

function AutomatonPanel:ResetButton(btn)
    local data = btn.data
    if data == nil or data.OnClick == nil then
        btn.icon:SetTexture(nil)
        btn.cooldown:Hide()
        btn:SetChecked(nil)
        btn:Disable()
    else
        btn.icon:SetTexture(data:GetIcon())
               
        if data:GetCooldown() then
            btn.cooldown:Show()
            btn.cooldown:SetCooldown(data:GetCooldown())
        else
            btn.cooldown:Hide()
        end
              
        btn:SetChecked(data:GetChecked())
        
        if data:GetEnabled() then
            btn:Enable()
        else
            btn:Disable()
        end
    end
end

function AutomatonPanel:OnClick(btn,click)
    local data = btn.data
    if data and data.OnClick then
        data:OnClick(click)
        self:ResetButton(btn)
    end
end

function AutomatonPanel:AddButton(button)
    local btn = self.Buttons[self.ButtonCount]
    btn.data = button
    self:ResetButton(btn)
    self.ButtonCount = self.ButtonCount + 1       
end

function AutomatonPanel:RemoveAllButtons()
    for i=0,self.ButtonCount-1,1 do
        local btn = self.Buttons[i]
        btn.data = nil
        self:ResetButton(btn)
    end
    self.ButtonCount = 0
end


function AutomatonPanel:OnEvent(event,...)
    for i=0,self.ButtonCount-1,1 do
        local btn = self.Buttons[i]
        local data = btn.data
        
        if data then
           data:OnEvent(event,...) 
           self:ResetButton(btn)
        end      
    end
end


