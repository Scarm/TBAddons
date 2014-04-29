TB2SpellBinder = {}

function TB2SpellBinder:OnLoad(frame)
     self.EventFrame = frame
    -- массив названий биндов
    self.SpellBinds = {}
    -- массив соотнесения спеллов и индикаторов
    self.Signals = {}
    -- массив названий команд
    self.Commands = {}
    self.Commands["startattack"] = 88
    self.Commands["stopattack"] = 89
    self.Commands["stopcasting"] = 90
    self.Commands["targetpet"] = 91
    self.Commands["petattack"] = 92
    self.Commands["assisttarget"] = 93
    self.Commands["targetnearestenemy"] = 94
    self.Commands["targetfocus"] = 95

    for i=0,11,1 do
        if i<9 then bind = i+1 end
        if i==9 then  bind = 0 end
        if i==10 then bind = "-" end
        if i==11 then bind = "=" end
        -- первая строка
        self.SpellBinds[i     ] = "CTRL-"..bind
        self.SpellBinds[i+12] = "ALT-"..bind
        self.SpellBinds[i+24] = "SHIFT-"..bind
        self.SpellBinds[i+36] = bind
        -- вторая строка
        self.SpellBinds[i+48] = "ALT-CTRL-"..bind
        self.SpellBinds[i+60] = "CTRL-SHIFT-"..bind
        self.SpellBinds[i+72] = "ALT-SHIFT-"..bind
        self.SpellBinds[i+84] = "ALT-CTRL-SHIFT-"..bind
    end

    self.SpellCount = 0
    self.Signals = {}
end

function TB2SpellBinder:PartyChanged()
    self.needUpdateParty = false
    ClearOverrideBindings(self.EventFrame.TargetFrame)
    self.Members = {}
    print("PartyChanged")

    if GetRealNumPartyMembers()>0 then
        self:PushMember( "player" )
        for i=1,GetNumPartyMembers(),1 do
            self:PushMember( "party"..i )
        end
    end
   
end

function TB2SpellBinder:PushMember(Name)
    local _,_,_,_,_,nm = GetPlayerInfoByGUID(UnitGUID(Name))
    self.Members[UnitGUID(Name)] = nm
    local n2 = GetUnitName(Name, true)   
    --print(Name,"|",nm,"|",n2)     
end


function TB2SpellBinder:UnregisterAllSpells()
    -- сбрасываем счетчик спеллов
    self.SpellCount = 0
    -- очищаем карту индикаторов
    self.Signals = {}
    ClearOverrideBindings(self.EventFrame.SpellFrame)
end

function TB2SpellBinder:RegisterSpell(ID)
    -- может быть забиндено только 36 спеллов
    if self.SpellCount==36 then
        return
    end

    local name,rank = GetSpellInfo(ID)
    if rank then
        name = name.."("..rank..")"
    end

    -- биндим спелл
    SetOverrideBindingSpell(self.EventFrame.SpellFrame, true, self.SpellBinds[self.SpellCount],name )
    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    self.Signals[ID] = self.SpellCount 
    self.SpellCount = self.SpellCount + 1
end

function TB2SpellBinder:BindCommands()
    print("bind commandes!")
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[88], "STARTATTACK" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[89], "STOPATTACK" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[90], "STOPCASTING" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[91], "targetpet" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[92], "petattack" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[93], "ASSISTTARGET" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[94], "TARGETNEARESTENEMY" )
    SetOverrideBinding(self.EventFrame.SpellFrame, true, self.SpellBinds[95], "targetfocus" )
end

function TB2SpellBinder:Command(cmd)
    if self.Commands[cmd] == nil then
        print("bad command!")
    else
        TB2Indicator:CastSpell(self.Commands[cmd])
    end
end

function TB2SpellBinder:CanCast(target,spell,isPetSpell,PowerLimit,RangeChecker)
    if IsHarmfulSpell(GetSpellInfo(spell)) then
        if isPetSpell==true then
            obj = "pet"
        else
            obj = "player"
        end

        local PowerType = select(6,GetSpellInfo(spell))
        local testlimit = 1
        if PowerLimit~=nil then
            if UnitPower(obj,PowerType)>=PowerLimit then
                testlimit = 1
            else
                testlimit = nil
            end

        else
            testlimit = 1
        end

        if RangeChecker==nil then
            RangeChecker = spell
        end

        local range = 1
        if SpellHasRange(GetSpellInfo(RangeChecker)) then
            if IsSpellInRange(GetSpellInfo(RangeChecker),target )==1 then
                range = 1
            else
                range = nil
            end
        end

        
        local et1 = select(6,UnitCastingInfo(obj))
        local et2 = select(6,UnitChannelInfo(obj))
        
        local readycast = 1
        if et1 then
            readycast = nil
        end
        if et2 then
            readycast = nil
        end
        --[[
        local readycast = 1
        local cast = UnitCastingInfo(obj) or UnitChannelInfo(obj)
        if cast then
            readycast = nil
        end
        --]]

        if UnitCanAttack(obj, target)
        and testlimit
        and range
        and readycast
        and GetSpellCooldown(GetSpellInfo(spell))==0
        and IsUsableSpell(GetSpellInfo(spell))
        and UnitIsDead(target)==nil
        and UnitIsDead(obj)==nil then
            return 1
        else
            return nil
        end
    else
        if RangeChecker==nil then
            RangeChecker = spell
        end

        local range = 1
        if SpellHasRange(GetSpellInfo(RangeChecker)) then
            if IsSpellInRange(GetSpellInfo(RangeChecker),target )==1 then
                range = 1
            else
                range = nil
            end
        end 

        if IsUsableSpell(spell)  
        and range
        and GetSpellCooldown(GetSpellInfo(spell))==0 then
            return 1
        else
            return nil
        end                               
        
    end
end

function TB2SpellBinder:CastSpell(spell)
    TB2Indicator:CastSpell(self.Signals[spell])
end

function TB2SpellBinder:Debuff(target,isMine,name)

    if isMine==true then
        expires = select(7,UnitDebuff(target,name,nil,"PLAYER"))
    else
        expires = select(7,UnitDebuff(target,name))
    end

    if expires==nil then
        return 0
    end

    local left = expires-GetTime()

    if left>0 then
        return expires-GetTime()
    else
        return 0
    end
end

function TB2SpellBinder:DebuffStacks(target,isMine,name)

    if isMine==true then
        count = select(4,UnitDebuff(target,name,nil,"PLAYER"))
    else
        count = select(4,UnitDebuff(target,name))
    end

    if count==nil then
        return 0
    end

    return count

end

function TB2SpellBinder:Buff(target,isMine,name)
    if isMine==true then
        expires = select(7,UnitBuff(target,name,nil,"PLAYER"))
    else
        expires = select(7,UnitBuff(target,name))
    end

    if expires==nil then
        return 0
    end

    -- для перманентных баффов
    if expires==0 then
        return 1
    end

    local left = expires-GetTime()

    if left>0 then
        return expires-GetTime()
    else
        return 0
    end
end

function TB2SpellBinder:CanGetAgro(target,spell)
    local ts = UnitThreatSituation("player", "playertarget")
    if ts~=nil 
    and ts<2
    and self:CanCast(target,spell,false) then
        return 1
    else
        return nil
    end
end

function TB2SpellBinder:CanInterrupt(target,spell)
    local i1 = select(9,UnitCastingInfo(target))
    local i2 = select(9,UnitChannelInfo(target))
    if TB2SpellBinder:CanCast(target,spell)
    and (i1==false or i2==false) then
        return 1
    else
        return nil
    end           
end


--[[
/script for i=1,25,1 do local f = _G["CompactRaidFrame"..i] if f then print(f.name:GetText(),"_",f:IsVisible()) end end


--]]



