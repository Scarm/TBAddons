PaladinRetri = CreateSpec("PALADIN","Retribution","Interface\\Icons\\Spell_Holy_AuraOfLight","Paladin Retribution")

function PaladinRetri:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(1,"Interface\\Icons\\Spell_Holy_CrusaderStrike","Single","Дамаг в одгу цель")
    Modes:AddMode(1,"Interface\\Icons\\Ability_Paladin_DivineStorm","AoE","АоЕ дамаг")

    Modes:AddMode(4,"Interface\\Icons\\Spell_Holy_HealingAura","Insight","Печать прозрения")
    Modes:AddMode(4,"Interface\\Icons\\Spell_Holy_SealOfVengeance","Truth","Печать правды")
    Modes:AddMode(4,"Interface\\Icons\\Spell_Holy_RighteousnessAura","Righteousness","Печать праведности")
end

function PaladinRetri:OnInitSpells(SpellBinder)
    --Seal of Truth
    SpellBinder:RegisterSpell(31801)
    --Seal of Insight
    SpellBinder:RegisterSpell(20165)
    --Seal of Righteousness
    SpellBinder:RegisterSpell(20154)

    --Judgement 
    SpellBinder:RegisterSpell(20271)
    --Crusader Strike 
    SpellBinder:RegisterSpell(35395)
    --Hammer of Wrath 
    SpellBinder:RegisterSpell(24275)
    --Exorcism 
    SpellBinder:RegisterSpell(879)
    --Inquisition 
    SpellBinder:RegisterSpell(84963)
    --Templar's Verdict 
    SpellBinder:RegisterSpell(85256)
    --Flash of Light 
    SpellBinder:RegisterSpell(19750)
    --Holy Light 
    SpellBinder:RegisterSpell(635)

    --Divine Storm 
    SpellBinder:RegisterSpell(53385)
    --Consecration 
    SpellBinder:RegisterSpell(26573)
    --Holy Wrath 
    SpellBinder:RegisterSpell(2812)
    
end

function PaladinRetri:OnInitButtons(SpellFrame)

end


function PaladinRetri:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end


    --Seal of Righteousness
    if SB:CanCast("player",20154)
    and TB2Modes.Values[4]=="Righteousness"
    and SB:Buff("player",true,GetSpellInfo(20154))==0 then
        return SB:CastSpell(20154)
    end
    --Seal of Insight
    if SB:CanCast("player",20165)
    and TB2Modes.Values[4]=="Insight"
    and SB:Buff("player",true,GetSpellInfo(20165))==0 then
        return SB:CastSpell(20165)
    end
    --Seal of Truth
    if SB:CanCast("player",31801)
    and TB2Modes.Values[4]=="Truth"
    and SB:Buff("player",true,GetSpellInfo(31801))==0 then
        return SB:CastSpell(31801)
    end

    --Flash of Light 
    if SB:CanCast("player",19750,false)
    and UnitAffectingCombat("player")
    and UnitHealth("player")<UnitHealthMax("player")*0.5
    and UnitCanAttack("player","playertarget") then
        return SB:CastSpell(19750)
    end

    --Inquisition
    if SB:CanCast("player",84963)
    and UnitAffectingCombat("player")
    and SB:Buff("player",true,GetSpellInfo(84963))==0 then
        return SB:CastSpell(84963)
    end

    if TB2Modes.Values[1]=="Single" then
        --Crusader Strike
        if SB:CanCast("playertarget",35395,false) then
            return SB:CastSpell(35395)
        end
    else
        --Divine Storm
        if SB:CanCast("playertarget",53385,false,nil,35395) then
            return SB:CastSpell(53385)
        end
        --Holy Wrath 
        if SB:CanCast("playertarget",2812,false,nil,35395) then
            return SB:CastSpell(2812)
        end
        --Consecration
        if SB:CanCast("playertarget",26573,false,nil,35395) then
            return SB:CastSpell(26573)
        end
    end

    --Hammer of Wrath
    if SB:CanCast("playertarget",24275,false) then
        return SB:CastSpell(24275)
    end


    --Templar's Verdict 
    if SB:CanCast("playertarget",85256,false)
    and SB:Buff("player",true,GetSpellInfo(86172))~=0 then
        return SB:CastSpell(85256)
    end  
    if SB:CanCast("playertarget",85256,false,3) then
        return SB:CastSpell(85256)
    end    

    --Exorcism
    if SB:CanCast("playertarget",879,false)
    and SB:Buff("player",true,GetSpellInfo(87138))~=0 then
        return SB:CastSpell(879)
    end

    --Judgement
    if SB:CanCast("playertarget",20271,false) then
        return SB:CastSpell(20271)
    end

    --Holy Wrath 
    if SB:CanCast("playertarget",2812,false,nil,35395) then
        return SB:CastSpell(2812)
    end

    --Consecration
    if SB:CanCast("playertarget",26573,false,UnitPowerMax("player")*0.5,35395) then
        return SB:CastSpell(26573)
    end

    --Holy Light 
    if SB:CanCast("player",635,false)
    and UnitAffectingCombat("player")==nil
    and UnitHealth("player")<UnitHealthMax("player")*0.7 then
        return SB:CastSpell(635)
    end
end

--GetSpellInfo(87138)
