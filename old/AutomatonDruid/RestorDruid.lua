RestorDruid = {}
setmetatable(RestorDruid, {__index = BaseClass})

RestorDruid.Name = "RestorDruid"
RestorDruid.Class = "DRUID"
RestorDruid.Talents = 4
RestorDruid.Spells = 
    {
        ["FoN"] = 33831,
        --["LB"] = 1,
        ["Rej"] = 774
        --["Cen"] = 3,
        --["HT"] = 4,
        --["Nor"] = 5
    }
RestorDruid.Buttons = 
    {
        --["FoN"] = ButtonsFactory:SpellButton( RestorDruid.Spells["FoN"] )
    }

    
    
function RestorDruid:OnUpdate()   
    if UnitIsDead("player") then return end

    local member
    local info
    local factor = -1
    for m,i in pairs(self.Raid.Members) do
        if i.Factor and i.Factor > factor and self:BuffElapsed("Rej", 1, member) == 0 and i.Factor > 0.1 then
            member = m
            info = i
            factor = i.Factor
        end
    end
    if factor <=0 then return end
    --print(factor,member)
    
    
    --local member = self:BestFor(0.1, function(m,i) return self:BuffElapsed("Rej", 1, m) == 0 end )
         
    if self:CanUse("Rej", member) and self:BuffElapsed("Rej", 1, member) == 0  then
        return self:Cast("Rej", member)
    end
    
end

Automaton:Register(RestorDruid)
 
