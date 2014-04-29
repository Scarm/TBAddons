TB2 = {}

function TB2:OnEvent(event,arg1,arg2,...)
    print("TB2 event=",event)
    if (event == "PLAYER_LOGIN") then
        -- тут полный список зареганых спеков на вес классы
        self:RegisterSpecs()
        -- создаем список кнопок для спеков класса
        self:CreateSpecButtons()

        if TB2.SpecButtonCount==0 then
            return
        end

        if TB2_Vars == nil then
            print("запуск с чистых настроек!")
            TB2_Vars = {}
            print(TB2.SpecButtons[0])
            print(TB2.SpecButtons[0].Spec)
            print("Первый спек:",TB2.SpecButtons[0].Spec.name )
            TB2:SetActiveSpec(TB2.SpecButtons[0].Spec) 
        else
            for i=0, self.SpecCount-1,1 do
                if self.SpecList[i].name == TB2_Vars.CurrentSpec then
                    TB2:SetActiveSpec(self.SpecList[i])
                end
            end
        end            
    end 
end

function TB2:CreateSpecButtons()
    local _,PlayerClass = UnitClass("player")
    TB2.SpecButtons = {}
    TB2.SpecButtonCount = 0
    TB2.isSpecsShown = false
    for i=0,self.SpecCount-1,1 do
        if self.SpecList[i].class == PlayerClass then
            btn = CreateFrame("Button","TB2SpecButton"..i,ModeFrame,"SpecButtonTemplate")
            btn:SetPoint("CENTER",TB2SpecButton,"CENTER",0,50+40*TB2.SpecButtonCount)
            btn.Spec = self.SpecList[i]
            btn:Hide()
            btn.icon:SetTexture(btn.Spec.icon)  
            TB2.SpecButtons[TB2.SpecButtonCount] = btn
            TB2.SpecButtonCount = TB2.SpecButtonCount+1
        end
    end
    print("Загружено спеков для класса:",TB2.SpecButtonCount)
end

function TB2:ShowSpecs()
    if TB2.isSpecsShown == false then
        for i=0,self.SpecButtonCount-1,1 do
            TB2.SpecButtons[i]:Show()
        end
        TB2.isSpecsShown = true
    end
end

function TB2:HideSpecs()
    if TB2.isSpecsShown == true then
        for i=0,self.SpecButtonCount-1,1 do
            TB2.SpecButtons[i]:Hide()
            TB2.isSpecsShown = false
        end
        TB2Modes.ModeFrame.CSB:SetChecked(false)
    end
end

function TB2:SetActiveSpec(spec)
    print("Set active spec",spec.name)
    TB2_Vars.CurrentSpec = spec.name
    TB2.CurrentSpec = spec
    TB2Modes.ModeFrame.CSB.icon:SetTexture(spec.icon)

    TB2Modes:Reset()
    TB2.CurrentSpec:OnInitModes(TB2Modes)
    TB2SpellBinder:UnregisterAllSpells()
    TB2.CurrentSpec:OnInitSpells(TB2SpellBinder)
    TB2SpellBinder:BindCommands()

    TB2:HideSpecs()    
end

function TB2:OnLoad(frame)
    self.SpecList = {}
    self.SpecCount = 0        
end

function TB2:AddSpec(Spec)
    self.SpecList[self.SpecCount] = Spec
    self.SpecCount = self.SpecCount+1
end


function TB2:OnUpdate()
    if TB2_Vars.CurrentSpec == nil then
        return
    end
    TB2Indicator:ClearControls()
    TB2.CurrentSpec:OnUpdate(TB2SpellBinder)
                
end


function TB2:RegisterSpecs()
    self:AddSpec(DruidBalance)
    self:AddSpec(DruidFeral) 
    self:AddSpec(HunterBM)
    self:AddSpec(HunterMM)
    self:AddSpec(ShamanElem)
    self:AddSpec(ShamanRestor)
    self:AddSpec(WarlockDemo)
    self:AddSpec(PriestDisc) 
    self:AddSpec(PriestShadow)
    self:AddSpec(PaladinRetri)    
    self:AddSpec(DKBlood) 
    self:AddSpec(RogueCombat)
    self:AddSpec(RogueSubtlety)
    self:AddSpec(WarProt)
	self:AddSpec(WarArms)
end













--[[

function CastSpell(ID)
    TB2Indicator:CastSpell( TB2SpellBinder.Signals[ID] )
end

function CanUseSpell(spell)
    local start, duration = GetSpellCooldown(spell)

    local rng = nil
    if SpellHasRange(spell) and IsSpellInRange(spell)==1 then
        rng = 1 end
    if SpellHasRange(spell)==nil then
        rng = 1 end

    if spell=="Размах(Облик медведя)" or spell=="Взбучка" then
        rng = IsSpellInRange("Увечье")
    end
    
    if UnitCanAttack("player", "playertarget")
    and IsUsableSpell(spell)
    and UnitIsDead("playertarget")==nil 
    and (start+duration-GetTime()<0.1)
    and rng
    then
        return 1
    else 
        return nil
    end
end
--]]
function CanUseBuff(spell)
    local start, duration = GetSpellCooldown(spell)
    if  IsUsableSpell(spell) and (start+duration-GetTime()<0.2) then
        return 1
    else 
        return nil
    end
end

function CanUse(spell)
    if IsHarmfulSpell(spell) then
        return CanUseSpell(spell)
    else
        return CanUseBuff(spell)
    end
end


-- фабрика для производства спеков
function CreateSpec(class,name,icon,tooltip)
    local spec = {}
    spec.class = class
    spec.name = name
    spec.icon = icon
    spec.toottip = tooltip

    -- эти методы должны быть переопределены, чтобы настроить спек

    -- здесь задаются режимы
    spec.OnInitModes = function(Modes)
        -- они задаются вот так:
        --Modes:AddMode(slot,icon,name,tooltip)
        -- slot - номер кнопки (начиная с 0), куда добавляем режим
    end
    -- здесь регистрируются спеллы по их ID
    spec.OnInitSpells = function(SpellBinder)
        -- добавляем спелл командой:
        -- SpellBinder:RegisterSpell(ID)
        -- Биндер сам разберется на какую кнопку можно повесить спелл
    end
    -- здесь устанавливаем кликабельные кнопки 
    -- (то, что нужно прожимать, или иметь    возможность отключить из ротации)
    spec.OnInitButtons = function(SpellFrame)
        --спелл добавляется по ID так:
        -- SpellFrame:SetButton(ID,position)
        --  position - номер кнопки начиная с 0
    end
    -- обработчик логики бота
    spec.OnUpdate = function(SpellBinder)
        -- if CanCast(target,spell,powerlimit,rangespell) then 
        --return CastSpell(target,spell) end 
        -- rangespell задает альтернативный спелл для проверки дистанции спелла
        -- если указано "nocheck" дистанция не проверяется вообще
    end
    -- заботить об очистке спеллов не нужно, этим занимается сам аддон
    return spec  
end



