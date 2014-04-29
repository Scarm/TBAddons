TB2Stress = {}
TB2Stress.Mobs = {}
TB2Stress.Count = 0

local Ppl = {}
    Ppl[1] = "Баблмен"
    Ppl[2] = "Катюнечка"
    Ppl[3] = "Шадокаар"
    --Ppl[4] = "Шадокаар"
    --Ppl[5] = "Корбик"
    --Ppl[6] = "Сайчег"

    
    
    

function TB2Stress:OnLogEvent(frame,event,...)
    local timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...) 
       
    frame.filter = nil
    if frame:GetName()=="TB2StressFramePlayer1" then
        frame.filter = "player"
    end
    if frame:GetName()=="TB2StressFramePlayer2" then
        frame.filter = "party1"
    end
    if frame:GetName()=="TB2StressFramePlayer3" then
        frame.filter = "party2"
    end
    if frame:GetName()=="TB2StressFramePlayer4" then
        frame.filter = "party3"
    end
    if frame:GetName()=="TB2StressFramePlayer5" then
        frame.filter = "party4"
    end
 
    local nm,realm = UnitName(frame.filter)
    if realm ~= nil then
        nm = nm.."-"..realm
    end
  
    if string.find(type,"_DAMAGE") and frame.filter and nm==destName then
        local amount,_,_,_,_,abs = select(13, ...)
        if type=="SWING_DAMAGE" then
            amount,_,_,_,_,abs = select(10, ...)
        end

        if type=="ENVIRONMENTAL_DAMAGE" then
            amount,_,_,_,_,abs = select(11, ...)
        end

        if abs~=nil then
            amount = amount+abs
        end

--[[
        if amount~=nil then
            frame.DPS:SetText(frame.DPS:GetText()+amount)
        end
--]]
        if amount~=nil then
            frame.Damage[GetTime()] = amount
        end
    end

    if string.find(type,"_HEAL") and frame.filter and nm==destName then
        local amount,_,abs = select(13, ...)

        if abs~=nil then
            amount = amount+abs
        end
--[[
        if amount~=nil then
            frame.HPS:SetText(frame.HPS:GetText()+amount)
        end  
--]]
        if amount~=nil then
            frame.Heal[GetTime()] = amount
        end          
    end
end

function TB2Stress:OnUpdate(frame)
    local sum = 0
    for time,amount in pairs(frame.Damage) do
        if GetTime()>time+10 then
            frame.Damage[time]=nil
        else
            sum = sum + amount
        end           
    end
    if frame.filter == nil then
        frame.DPS:SetText(0)
    else
        frame.DPS:SetText( 100*sum/(UnitHealthMax(frame.filter)) )
    end

    sum = 0
    for time,amount in pairs(frame.Heal) do
        if GetTime()>time+10 then
            frame.Heal[time]=nil
        else
            sum = sum + amount
        end           
    end
    if frame.filter == nil then
        frame.HPS:SetText(0)
    else
        frame.HPS:SetText( 100*sum/(UnitHealthMax(frame.filter)) )
    end
end


function TB2Stress:MobCounter(frame,event,...)
    if event=="COMBAT_LOG_EVENT_UNFILTERED" then
        local type = select(2, ...)
        local dest = select(7, ...)
        if type=="UNIT_DIED" then
            self.Mobs[dest] = nil
            self:UpdCounter(frame)     
        end


        if type=="SPELL_CAST_START"  then
            local spell = select(13, ...)
            if spell=="Осколки мучений" then
                if self.Crystall==nil then self.Crystall=0 end
                self.Crystall = self.Crystall+1
                if self.Crystall>3 then
                    self.Crystall=1
                end

                print("Людей хилит  "..Ppl[self.Crystall])                            
                --SendChatMessage("Людей хилит  "..Ppl[self.Crystall], "WHISPER", nil, Ppl[self.Crystall])
                SendChatMessage("Людей хилит  "..Ppl[self.Crystall], "RAID_WARNING")
                --self.Crystall = self.Crystall+1
                --SendChatMessage("Людей хилит  "..Ppl[self.Crystall], "RAID_WARNING")
            end
        end


--[[[ номера спеллов!!!  Осколки мучений
        if type=="SPELL_CAST_SUCCESS" then
            local id,nm= select(10, ...)
            print(id,nm)
        end
--]]
    end

    if event=="UPDATE_MOUSEOVER_UNIT" then
        if ( UnitIsPlayer("mouseovertarget")~=nil or UnitThreatSituation("player", "mouseover")~=nil) then
            local range = 1
            if self.RangeChecker and SpellHasRange(GetSpellInfo(self.RangeChecker)) then
                if IsSpellInRange(GetSpellInfo(self.RangeChecker),target )==1 then
                    range = 1
                else
                    range = nil
                end
            end
            if UnitCanAttack("player", "mouseover")
            and range
            and UnitIsDead("mouseover")==nil
            and UnitIsDead("player")==nil then
                self.Mobs[UnitGUID("mouseover")] = GetTime() 
            else
                self.Mobs[UnitGUID("mouseover")] = nil
            end
        end
        self:UpdCounter(frame)
    end

    if event=="PLAYER_REGEN_ENABLED" then
        self.Mobs = {}
        self:UpdCounter(frame)
        self.Crystall=nil 
    end
    if event=="PLAYER_REGEN_DISABLED" then
        self.Crystall=nil
        print("Crystal reset")
    end 
end

function TB2Stress:UpdCounter(frame)
    self.Count = 0;
    for index,value in pairs(self.Mobs) do
        if value+5<GetTime() then
            self.Mobs[index] = nil
        end
    end
    for index,value in pairs(self.Mobs) do
        self.Count = self.Count+1;   
    end
    
end

function TB2Stress:PrevCastScan(frame,event,...)
    if event=="COMBAT_LOG_EVENT_UNFILTERED" then
        local type = select(2, ...)
        local src = select(4, ...)
        local spellname = select(12, ...)

        if type=="SPELL_CAST_START" and src==UnitGUID("player") then
            self.prevcastend = select(6,UnitCastingInfo("player"))
            self.PrevCast = spellname
            print(self.prevcastend,self.PrevCast);
            --print(...)
              
        end

        if type=="SPELL_CAST_FAILED" and src==UnitGUID("player") and spellname==self.PrevCast then
            print(type,spellname)
            self.prevcastend = nil
            self.PrevCast = nil 
        end
    end
end

function TB2Stress:UpdCastScan(frame)
    if self.prevcastend 
    and (self.prevcastend+1000)<(GetTime()*1000) then
        self.prevcastend = nil
        self.PrevCast = nil 
    end

    if (self.PrevCast) then
        frame.Counter:SetText(self.PrevCast)
    else
        frame.Counter:SetText("---")
    end

end




