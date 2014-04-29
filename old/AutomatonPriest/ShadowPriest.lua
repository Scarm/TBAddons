print("ShadowPriest.lua")
ShadowPriest = {}
local spec = ShadowPriest

spec.Name = "ShadowPriest"
spec.Class = "PRIEST"
spec.Talents = 1
spec.Spells = 
    {

    }
spec.Buffs = 
    {

    }
    
    
spec.Buttons = 
    {

    }

    
local function CanCast(name) 
    return Automaton:CanCast(spec.Spells[name]) 
end
local function CastSpell(name,target) 
    return Automaton:CastSpell(spec.Spells[name],target) 
end
local function DebuffElapsed(name,target) 
    return Automaton:AuraElapsed(spec.Spells[name],target,"HARMFUL|PLAYER") 
end
local function BuffElapsed(name) 
    return Automaton:AuraElapsed(spec.Spells[name] or spec.Buffs[name],"player","HELPFUL") 
end
local function BuffStack(name) 
    return Automaton:AuraStack(spec.Spells[name] or spec.Buffs[name],"player","HELPFUL") 
end
    
function spec:OnUpdate()  

end

--Automaton:Register(spec)

 
