BalanceDruid = {}
setmetatable(BalanceDruid, {__index = BaseClass})
BalanceDruid.Name = "BalanceDruid"
BalanceDruid.Class = "DRUID"
BalanceDruid.Talents = 1
BalanceDruid.Spells = 
    {
        ["Starfire"] = 2912,
        ["Wrath"] = 5176,
        ["Starsurge"] = 78674,
        ["MF"] = 8921,
        ["SF"] = 93402,
        ["FoN"] = 106737,
        ["Cen"] = 102351,
        ["Rej"] = 774,
    }
BalanceDruid.Buttons = 
    {
        ["FoN"] = SpellButton:Create( BalanceDruid.Spells["FoN"],"target" )
    }

   
function BalanceDruid:OnUpdate()   
    if IsMounted() then return end
    
    
    local hpp = UnitHealth("player")/UnitHealthMax("player")   
    if self:CanUse("Rej", self.Raid.Player) and self:BuffElapsed("Rej",1) < 3 and hpp < 0.8 then
        return self:Cast("Rej", self.Raid.Player)
    end
    
    if self:CanUse("Cen", self.Raid.Player) and UnitAffectingCombat("player") and hpp < 0.5 then
        return self:Cast("Cen", self.Raid.Player)
    end
    
   
    
    if GetEclipseDirection() == "sun" then
        if self:CanUse("MF","target") and self:DebuffElapsed("MF",1)==0 then           
            return self:Cast("MF")
        end
    
        if self:CanUse("SF","target") and self:DebuffElapsed("SF",1)==0 then
            return self:Cast("SF")
        end
    
        
        if self:CanUse("Starsurge","target") then
            return self:Cast("Starsurge")
        end
        
        if self:CanUse("Starfire","target") then
            return self:Cast("Starfire")
        end
        
    else
        if self:CanUse("SF","target") and self:DebuffElapsed("SF",1)==0 then           
            return self:Cast("SF")
        end

        if self:CanUse("MF","target") and self:DebuffElapsed("MF",1)==0 then
            return self:Cast("MF")
        end
    
        if self:CanUse("Starsurge","target") then
            return self:Cast("Starsurge")
        end
        
        if self:CanUse("Wrath","target") then
            return self:Cast("Wrath")
        end
  
    end
    

    return nil
end

Automaton:Register(BalanceDruid)
