DKBlood = CreateSpec("DEATHKNIGHT","Blood","Interface\\Icons\\Spell_Holy_AuraOfLight","Blood Death Knight")

function DKBlood:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(1,"Interface\\Icons\\Spell_Holy_CrusaderStrike","Single","Дамаг в одгу цель")
    Modes:AddMode(1,"Interface\\Icons\\Ability_Paladin_DivineStorm","AoE","АоЕ дамаг")
end

function DKBlood:OnInitSpells(SpellBinder)
    --Icy Touch
    SpellBinder:RegisterSpell(45477)
    --Plague Strike
    SpellBinder:RegisterSpell(45462)
    --Death Strike
    SpellBinder:RegisterSpell(49998)   
    --Heart Strike
    SpellBinder:RegisterSpell(55050)
    --Rune Strike
    SpellBinder:RegisterSpell(56815)
    --Pestilence
    SpellBinder:RegisterSpell(50842)
    --Blood Boil
    SpellBinder:RegisterSpell(48721)

    --Dark Command
    SpellBinder:RegisterSpell(56222)

    --Mind Freeze
    SpellBinder:RegisterSpell(47528)
end

function DKBlood:OnInitButtons(SpellFrame)

end


function DKBlood:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if UnitIsPlayer("targettarget")==nil and UnitThreatSituation("player", "playertarget")==nil  then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end

    --Mind Freeze
    if SB:CanInterrupt("playertarget",47528) then
        return SB:CastSpell(47528)
    end

    --Dark Command
    if SB:CanGetAgro("playertarget",56222) then
        return SB:CastSpell(56222)
    end

    --Pestilence
    if SB:CanCast("playertarget",50842,false) 
    and SB:Debuff("playertarget",true,GetSpellInfo(59921))>0
    and SB:Debuff("playertarget",true,GetSpellInfo(59879))>0
    and SB:CanCast("mouseover",55050,false) 
    and (SB:Debuff("mouseover",true,GetSpellInfo(59921))==0 or SB:Debuff("mouseover",true,GetSpellInfo(59879))==0) then
        return SB:CastSpell(50842)
    end

    --Heart Strike
    if SB:CanCast("playertarget",55050,false)
    and GetRuneCooldown(1)+GetRuneCooldown(2)==0 then
        return SB:CastSpell(55050)
    end

    --Rune Strike
    if SB:CanCast("playertarget",56815,false,60) then
        return SB:CastSpell(56815)
    end

    --Icy Touch
    if SB:CanCast("playertarget",45477,false) 
    and SB:Debuff("playertarget",true,GetSpellInfo(59921))==0 then
        return SB:CastSpell(45477)
    end

    --Plague Strike
    if SB:CanCast("playertarget",45462,false) 
    and SB:Debuff("playertarget",true,GetSpellInfo(59879))==0 then
        return SB:CastSpell(45462)
    end

    --Death Strike
    if SB:CanCast("playertarget",49998,false) then
        return SB:CastSpell(49998)
    end




    if TB2Stress.Count<3 then
        --Heart Strike
        if SB:CanCast("playertarget",55050,false)
        and GetRuneCooldown(1)*GetRuneCooldown(2)==0 then
            return SB:CastSpell(55050)
        end
    else
        --Blood Boil
        if SB:CanCast("playertarget",48721,false) 
        and SB:Debuff("playertarget",true,GetSpellInfo(59921))~=0
        and SB:Debuff("playertarget",true,GetSpellInfo(59879))~=0 then
            return SB:CastSpell(48721)
        end
    end



end
