print("RaidScanner.lua")

AutomatonRaid = CreateFrame("Frame","AutomatonRaidFrame",UIParent)
-- синоним, для всех других частей бота AutomatonRaid должен быть доступен через этот синоним
-- нужно возможности простой подмены реализации
Automaton.Raid = AutomatonRaid
AutomatonRaid.EventHandler = EventHandler:Create(AutomatonRaid, 
    {
        ["PLAYER_LOGIN"] = "OnRaidChanged",
        ["GROUP_ROSTER_UPDATE"] = "OnRaidChanged",
        ["PARTY_CONVERTED_TO_RAID"] = "OnRaidChanged",
        ["PLAYER_REGEN_ENABLED"] = "OnExitCombat",
        ["PLAYER_REGEN_DISABLED"] = "ResetAccumulators",
        ["COMBAT_LOG_EVENT_UNFILTERED"] = "OnCombatLog"
    }) 
AutomatonRaid.EventHandler:RegisterEvents(eventFrame) 
AutomatonRaid.timer = GetTime()    
 
--[[    
function AutomatonRaid:OnLoad(eventFrame)
    print("AutomatonRaid:OnLoad")
    self.EventHandler:RegisterEvents(eventFrame) 
    self.timer = GetTime()
end
--]]
    
function AutomatonRaid:OnEvent(event,...)
    self.EventHandler:OnEvent(event,...)
end

function AutomatonRaid:OnRaidChanged()
    if UnitAffectingCombat("player") then
       self.RaidChanged = 1 
    else
        self:RegisterMembers()
    end        
end

function AutomatonRaid:OnCombatLog(event,...)
    local _,logevent,_,_,sourceName,_,_,_,destName = select(1, ...)
   
    if strfind(logevent,".*_DAMAGE$") then
        local amount = select(15, ...)
        if logevent == "SWING_DAMAGE" then
            amount = select(12, ...)
        end
        local info = self.Members[destName]      
        if info then
            --print(logevent,amount)
            info.damage:Push(GetTime(),amount)
        end      
    end
end

function AutomatonRaid:OnExitCombat()
    if self.RaidChanged then
        self:RegisterMembers()
    end        
end

function AutomatonRaid:ResetAccumulators()
    for nm,info in pairs(self.Members) do
        info.damage:Reset()
    end
end


function AutomatonRaid:OnUpdate(elapsed)
    local now = GetTime()
    if now - self.timer < 0.2 then
        return
    end
    self.timer = now
    
    for nm,info in pairs(self.Members) do
        info.damage:Evaluate(GetTime())
        self:ComplexFactor(nm,info)
        info.Enabled = UnitIsConnected(nm) and not UnitIsDead(nm)
    end
       
end

AutomatonRaid.k10 = 5
AutomatonRaid.k20 = 5 
-- расчет комплексного показателя критичности для хила
function AutomatonRaid:ComplexFactor(member,info)
    local hpMax = UnitHealthMax(member)
    local hp = hpMax - UnitHealth(member) -- потеряное хп
    local result = info.damage.Stats[10]/10 * self.k10
                 + info.damage.Stats[20]/20 * self.k20
                 + hp
    info.Factor = result / hpMax
end

function AutomatonRaid:FactorList()
    local result = {}
    for nm,info in pairs(self.Members) do
        table.insert(result, {name = nm, factor = info.Factor})
    end
    table.sort(result,function(a,b) return a.factor<b.factor end)
    return result
end

function AutomatonRaid:List()
   for k,f in pairs(self:FactorList()) do
      print(f.name,f.factor) 
   end
end
   
function AutomatonRaid:RegisterMembers()
    print("AutomatonRaid:RegisterMembers")
    self.Members = {}  
    Automaton.Indicator:UnregisterAllTargets()
    self.Player = UnitName("player")

    local members = GetNumGroupMembers()
    
    if members == 0 then
        self:CreateMember(self.Player)
    else    
        for i = 1, members, 1 do 
            local name = GetRaidRosterInfo(i)
            self:CreateMember(name)
        end
    end
    self.RaidChanged = nil
end

function AutomatonRaid:CreateMember(name)
    if name then
        local info = {}
        info.damage = Accumulator:Create({10, 20})
        Automaton.Indicator:RegisterTarget(name)

        self.Members[name] = info
    end
end

function AutomatonRaid:Contains(unit)
    for member,info in pairs(self.Members) do
        if UnitIsUnit(member, unit) then
            return 1
        end
    end
end


