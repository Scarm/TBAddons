print("ArmsWarrior.lua")
ArmsWarrior = {}
local spec = ArmsWarrior

spec.Name = "ArmsWarrior"
spec.Class = "WARRIOR"
spec.Talents = 1
spec.Spells = 
    {
        ["Mortal"] = 12294,
        ["Colossus"] = 86346,
        ["Overpower"] = 7384,
        ["Slam"] = 1464,
        ["Execute"] = 5308,
        ["Heroic"] = 78
    }
spec.Buffs = 
    {
        ["TfB"] = 56638,
    }
    
    
spec.Buttons = 
    {
        ["AoE"] = ButtonsFactory:ToggleButton({
                ["Single"] = "Interface\\Icons\\Ability_Warrior_RallyingCry",
                ["Multi"] = "Interface\\Icons\\Ability_Warrior_BattleShout"
            }),
        ["Mortal"] = ButtonsFactory:SpellButton( spec.Spells["Colossus"] )
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
    if CanCast("Heroic") and BuffElapsed("TfB")<2 then
        return CastSpell("Heroic","target")
    end

    if CanCast("Heroic") and BuffStack("TfB")==5 then
        return CastSpell("Heroic","target")
    end

    if CanCast("Colossus") and DebuffElapsed("Colossus","target")==0 then
        return CastSpell("Colossus","target")
    end

    if CanCast("Overpower") then
        return CastSpell("Overpower","target")
    end

    if CanCast("Mortal") then
        return CastSpell("Mortal","target")
    end

    if CanCast("Slam") and UnitPower("player")>60 then
        return CastSpell("Slam","target")
    end
end

--Automaton:Register(spec)

