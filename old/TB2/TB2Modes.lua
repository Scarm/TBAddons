TB2Modes = {}
TB2ModeButtons = 5

function TB2Modes:OnLoad(ModeFrame)
    TB2Modes.ModeFrame = ModeFrame
    TB2Modes.Buttons = {}
    TB2Modes.Values = {}
    for i=0,TB2ModeButtons-1,1 do
        btn = CreateFrame("Button","TB2ModeButton"..i,ModeFrame,"ModeButtonTemplate")
        btn:SetPoint("TOPLEFT",17+40*i ,-17 )
        btn.Slot = i 
        self:ResetButton(btn)  
        TB2Modes.Buttons[i] = btn 
    end  
end

function TB2Modes:SavePos(ModeFrame)
    if TB2_Vars == nil then
        return
    end
    -- если выбран спек (т.е. он наверное существует) тогда создадим если надо таблицу и сохраним туда позицию
    if TB2_Vars.ModeFrame==nil then
        TB2_Vars.ModeFrame = {}
    end

    local p,_,_,x,y = ModeFrame:GetPoint()
    TB2_Vars.ModeFrame.x = x
    TB2_Vars.ModeFrame.y = y
    TB2_Vars.ModeFrame.point = p
end

function TB2Modes:LoadPos(ModeFrame)
    -- если не выбран спек или еще не сохранялись настройки - просто выходим
    if ( TB2_Vars == nil )or( TB2_Vars.ModeFrame==nil )  then
        return
    end

    local spec = TB2_Vars.ModeFrame
    ModeFrame:SetPoint( spec.point, spec.x, spec.y );
end

function TB2Modes:Reset()
    for i=0,TB2ModeButtons-1,1 do
        self:ResetButton(TB2Modes.Buttons[i])  
    end  
end

function TB2Modes:ResetButton(button)
    button.ModeCount = 0
    button.SelectedMode = nil
    button.Icons = {}
    button.ModeNames = {}
    button.ToolTips = {}
    self:SetButton(button)
end

function TB2Modes:SetButton(button)
    if button.SelectedMode == nil then
        self.Values[button.Slot] = nil
        button:Disable()
        
        button.icon:SetTexture(nil)
        -- сюда вставить код для очистки слота, когда не установлено вообще модов
        -- нужно сделать слот некликабельным вообще
        -- Gametooltip!!
    else
        self.Values[button.Slot] = button.ModeNames[button.SelectedMode]
        button:Enable()

        button.icon:SetTexture(button.Icons[button.SelectedMode])
    

        -- здесь устанавливаем иконку
        -- не забыть сделать слот кликабельным
    end
end

function TB2Modes:AddMode(slot,icon,name,tooltip)
    btn = TB2Modes.Buttons[slot]
  
    btn.Icons[btn.ModeCount] = icon
    btn.ModeNames[btn.ModeCount] = name
    btn.ToolTips[btn.ModeCount] = tooltip

    if btn.SelectedMode==nil then
        btn.SelectedMode = btn.ModeCount
        self:SetButton(btn)
    end

    btn.ModeCount = btn.ModeCount+1
end

function TB2Modes:SwitchUp(button)
    if (button.ModeCount<2) or (button.SelectedMode== (button.ModeCount-1) ) then 
        return 
    end
    button.SelectedMode = button.SelectedMode+1;
    self:SetButton(button);  
end

function TB2Modes:SwitchDown(button)
    if (button.ModeCount<2) or (button.SelectedMode==0) then 
        return 
    end
    button.SelectedMode = button.SelectedMode-1;
    self:SetButton(button);    
end


--[[

/script SetOverrideBindingSpell(UIParent, true, "F8", GetSpellInfo(1742) )


/script SetOverrideBinding(UIParent, true, "F8", "petfollow" )
ASSISTTARGET
STARTATTACK
STOPATTACK
STOPCASTING
petattack
petfollow
targetlasttarget
TARGETNEARESTENEMY
targetpet

ALT-CTRL-SHIFT

/script CreateMacro("TB2", 1, "/target[modifier:shift] Тренировочный манекен", 1);SetOverrideBindingMacro(UIParent, true, "F8","bindmacro")

/script print( GetMouseFocus():GetName() )
 
/script SetOverrideBindingClick(UIParent, true, "F8", "PartyMemberFrame3","LeftButton")


/script local name,rank = GetSpellInfo(5176) local nm = name.."("..rank..")" SetOverrideBindingSpell(UIParent, true, "F8", nm ) print(nm)
/script local name,rank = GetSpellInfo(5176) print(name,rank)

/script ClearOverrideBindings(UIParent)

/script DeleteMacro("bindmacro")

/script print("_",UnitGUID(GetUnitName("party1",false)))

/script print("_",GetUnitName("party1",false))

SetOverrideBindingMacro(UIParent, true, key ,CreateMacro("TB2Bind"..i, 1, "/target "..name, 1))
--]]
