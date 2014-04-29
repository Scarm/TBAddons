WarlockDemo = CreateSpec("WARLOCK","Demonology","Interface\\Icons\\Spell_Shadow_Metamorphosis","Warlock Demonology")

function WarlockDemo:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")
end

function WarlockDemo:OnInitSpells(SpellBinder)
    --Immolate
    SpellBinder:RegisterSpell(348)
    --Corruption
    SpellBinder:RegisterSpell(172)
    --Bane of Agony
    SpellBinder:RegisterSpell(980)
    --Shadow Bolt
    SpellBinder:RegisterSpell(686)
    --Soulburn
    SpellBinder:RegisterSpell(74434)
    --Soul Fire
    SpellBinder:RegisterSpell(6353)
    --Hand of Gul'dan
    SpellBinder:RegisterSpell(71521)
    --Drain Soul
    SpellBinder:RegisterSpell(1120)

end

function WarlockDemo:OnInitButtons(SpellFrame)

end


function WarlockDemo:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end

    if UnitIsUnit("target","pettarget")==nil
    and UnitIsDead("target")==nil
    and UnitIsDead("pet")==nil
    and UnitCanAttack("player", "playertarget") then
        SB:Command("petattack")
    end


    --Soul Fire
    if SB:CanCast("playertarget",6353,false)
    and SB:Buff("player",true,GetSpellInfo(74434))>0 then
        return SB:CastSpell(6353)
    end

    --Drain Soul
    

    if SB:CanCast("playertarget",1120,false)
    and UnitClassification("playertarget")=="normal"
    and UnitHealth("playertarget")<UnitHealthMax("playertarget")*0.2 then
        return SB:CastSpell(1120)
    end
	
    if SB:CanCast("playertarget",1120,false)
    and UnitHealth("playertarget")<UnitHealthMax("playertarget")*0.1 then
        return SB:CastSpell(1120)
    end
    --Immolate
    if SB:CanCast("playertarget",348,false)
    and TB2Stress.PrevCast~= 348
    and SB:Debuff("playertarget",true,GetSpellInfo(348))==0 then
        return SB:CastSpell(348)
    end
    --Corruption
    if SB:CanCast("playertarget",172,false)
    and SB:Debuff("playertarget",true,GetSpellInfo(172))==0 then
        return SB:CastSpell(172)
    end
    --Bane of Agony
    if SB:CanCast("playertarget",980,false)
    and SB:Debuff("playertarget",true,GetSpellInfo(980))==0 then
        return SB:CastSpell(980)
    end

    --Hand of Gul'dan
    if SB:CanCast("playertarget",71521,false) then
        return SB:CastSpell(71521)
    end

    --Soulburn
    if SB:CanCast("playertarget",6353,false) 
    and SB:CanCast("player",74434,false) then
        return SB:CastSpell(74434)
    end

    --Shadow Bolt
    if SB:CanCast("playertarget",686,false) then
        return SB:CastSpell(686)
    end
end
