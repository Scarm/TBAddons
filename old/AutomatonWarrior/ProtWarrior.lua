print("ProtWarrior.lua")
ProtWarrior = {}
local spec = ProtWarrior

spec.Name = "ProtWarrior"
spec.Class = "WARRIOR"
spec.Talents = 3
spec.Spells = 
    {
        ["CShout"] = 469,
        ["BShout"] = 6673,
        ["Pummel"] = 6552,
        ["SSlam"] = 23922,
        ["Dev"] = 20243,
        ["Rev"] = 6572
    }

spec.Buttons = 
    {
        ["Shout"] = ButtonsFactory:ToggleButton({
                ["CShout"] = "Interface\\Icons\\Ability_Warrior_RallyingCry",
                ["BShout"] = "Interface\\Icons\\Ability_Warrior_BattleShout"
            })
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
    local shoutMode = self.Buttons["Shout"].Mode

    if shoutMode == "CShout" then
        if CanCast("CShout") and BuffElapsed("CShout")==0 then
            return CastSpell("CShout")
        end
    else
        if CanCast("BShout") and BuffElapsed("BShout")==0 then
            return CastSpell("BShout")
        end
    end


    if CanCast("SSlam") then
        return CastSpell("SSlam","target")
    end
--[[
    if CanCast("Rev") then
        return CastSpell("Rev","target")
    end   
 --]]         
    if CanCast("Dev") then
        return CastSpell("Dev","target")
    end
end

--Automaton:Register(spec)

