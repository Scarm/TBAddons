PriestDisc = CreateSpec("PRIEST","Discipline","Interface\\Icons\\Spell_Holy_GuardianSpirit","Priest Discipline")

function PriestDisc:OnInitModes(Modes)

end

function PriestDisc:OnInitSpells(SpellBinder)

end

function PriestDisc:OnInitButtons(SpellFrame)

end


function PriestDisc:OnUpdate(SB)
    if IsMounted() then return end

end

PriestShadow = CreateSpec("PRIEST","Shadow","Interface\\Icons\\Spell_Shadow_ShadowWordPain","Priest Shadow")

function PriestShadow:OnInitModes(Modes)

end

function PriestShadow:OnInitSpells(SpellBinder)
    --Shadowform
    SpellBinder:RegisterSpell(15473)
    --Vampiric Embrace
    SpellBinder:RegisterSpell(15286)
    --Inner Fire
    SpellBinder:RegisterSpell(588)
    --Shadow Word: Pain
    SpellBinder:RegisterSpell(589)

    --Devouring Plague
    SpellBinder:RegisterSpell(2944)
    --Vampiric Touch
    SpellBinder:RegisterSpell(34914)

    --Mind Blast
    SpellBinder:RegisterSpell(8092)
    --Mind Flay
    SpellBinder:RegisterSpell(15407)
    --Shadow Word: Death
    SpellBinder:RegisterSpell(32379)
    --Power Word: Shield
    SpellBinder:RegisterSpell(17)

end

function PriestShadow:OnInitButtons(SpellFrame)

end


function PriestShadow:OnUpdate(SB)
    if IsMounted() then return end

    --Shadowform
    if SB:CanCast("player",15473,false)
    and SB:Buff("player",true,GetSpellInfo(15473))==0
    then
        return SB:CastSpell(15473)
    end

    --Vampiric Embrace
    if SB:CanCast("player",15286,false)
    and SB:Buff("player",true,GetSpellInfo(15286))==0
    then
        return SB:CastSpell(15286)
    end

    --Inner Fire
    if SB:CanCast("player",588,false)
    and SB:Buff("player",true,GetSpellInfo(588))==0
    then
        return SB:CastSpell(588)
    end

    --Power Word: Shield
    if SB:CanCast("player",17,false)
    and SB:Buff("player",true,GetSpellInfo(17))==0
    and UnitHealth("player")<0.8*UnitHealthMax("player") 
    and UnitAffectingCombat("player")
    then
        return SB:CastSpell(17)
    end

    --Shadow Word: Death
    if SB:CanCast("playertarget",32379,false)
    and UnitHealth("player")>0.5*UnitHealthMax("player")
    and UnitPower("player")<0.7*UnitPowerMax("player")then
        return SB:CastSpell(32379)
    end

    --Shadow Word: Pain
    if SB:CanCast("playertarget",589,false)
    --and UnitClassification("playertarget")~="normal" 
    and SB:Debuff("playertarget",true,GetSpellInfo(589))<2 then
        return SB:CastSpell(589)
    end

    --Devouring Plague
    if SB:CanCast("playertarget",2944,false)
    --and UnitClassification("playertarget")~="normal" 
    and SB:Debuff("playertarget",true,GetSpellInfo(2944))<2 then
        return SB:CastSpell(2944)
    end
    if SB:CanCast("playertarget",2944,false)
    and UnitClassification("playertarget")=="normal" 
    and UnitHealth("player")<0.8*UnitHealthMax("player") 
    and SB:Debuff("playertarget",true,GetSpellInfo(2944))<2 then
        return SB:CastSpell(2944)
    end

    --Vampiric Touch
    if SB:CanCast("playertarget",34914,false)
    and TB2Stress.PrevCast~= 34914 
    and SB:Debuff("playertarget",true,GetSpellInfo(34914))<3 then
        return SB:CastSpell(34914)
    end

    --Mind Blast
    if SB:CanCast("playertarget",8092,false) then
        return SB:CastSpell(8092)
    end

    --Mind Flay
    if SB:CanCast("playertarget",15407,false) then
        return SB:CastSpell(15407)
    end


end
