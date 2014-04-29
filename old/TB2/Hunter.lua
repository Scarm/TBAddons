HunterBM = CreateSpec("HUNTER","BeastMastery","Interface\\Icons\\Ability_Hunter_SickEm","Hunter Beast Mastery")

function HunterBM:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(1,"Interface\\Icons\\Ability_TrueShot","Single","Дамаг в одгу цель");
    Modes:AddMode(1,"Interface\\Icons\\Ability_UpgradeMoonGlaive","AoE","АоЕ дамаг");
end

function HunterBM:OnInitSpells(SpellBinder)
    --Kill Shot
    SpellBinder:RegisterSpell(53351)
    --Multi-Shot
    SpellBinder:RegisterSpell(2643)
    --Serpent Sting
    SpellBinder:RegisterSpell(1978)
    --Kill Command
    SpellBinder:RegisterSpell(34026)
    --Arcane Shot
    SpellBinder:RegisterSpell(3044)
    --Widow Venom
    SpellBinder:RegisterSpell(82654)
    --Cobra Shot
    SpellBinder:RegisterSpell(77767)
		
end

function HunterBM:OnInitButtons(SpellFrame)

end


function HunterBM:OnUpdate(SB)
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

    --Kill Shot
    if SB:CanCast("playertarget",53351,false) then
        return SB:CastSpell(53351)
    end
	
	--Widow Venom
	if SB:CanCast("playertarget",82654,false) 
	and SB:Debuff("playertarget",true,GetSpellInfo(82654))==0 then
		return SB:CastSpell(82654)
	end

    if TB2Modes.Values[1]=="AoE" then
        --Multi-Shot
        if SB:CanCast("playertarget",2643,false) then
            return SB:CastSpell(2643)
        end
    end

     if TB2Modes.Values[1]=="Single" then         

        --Serpent Sting
        if SB:CanCast("playertarget",1978,false) 
        and SB:Debuff("playertarget",true,GetSpellInfo(1978))==0 then
            return SB:CastSpell(1978)
        end
		
        --Kill Command
        if SB:CanCast("playertarget",34026,false)
		and UnitCanAttack("player", "playertarget") then
            return SB:CastSpell(34026)
        end
		
        --Arcane Shot
        if SB:CanCast("playertarget",3044,false)
		and UnitPower("player")>80 then
            return SB:CastSpell(3044)
        end				
		

        --Cobra Shot
        if SB:CanCast("playertarget",77767,false) then
            return SB:CastSpell(77767)
        end
    end       
end

HunterMM = CreateSpec("HUNTER","Marksmanship","Interface\\Icons\\Ability_Hunter_ThrilloftheHunt","Hunter Marksmanship")

function HunterMM:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(1,"Interface\\Icons\\Ability_TrueShot","Single","Дамаг в одгу цель");
    Modes:AddMode(1,"Interface\\Icons\\Ability_UpgradeMoonGlaive","AoE","АоЕ дамаг");
end

function HunterMM:OnInitSpells(SpellBinder)
    --Chimera Shot
    SpellBinder:RegisterSpell(53209)
    --Aimed Shot
    SpellBinder:RegisterSpell(19434)
    --Steady Shot
    SpellBinder:RegisterSpell(56641)
    --Serpent Sting
    SpellBinder:RegisterSpell(1978)
    --Kill Shot
    SpellBinder:RegisterSpell(53351)
    --Multi-Shot
    SpellBinder:RegisterSpell(2643)
end

function HunterMM:OnInitButtons(SpellFrame)

end

function HunterMM:OnUpdate(SB)
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

    --Kill Shot
    if SB:CanCast("playertarget",53351,false) then
        return SB:CastSpell(53351)
    end

    if TB2Modes.Values[1]=="AoE" then
        --Multi-Shot
        if SB:CanCast("playertarget",2643,false) then
            return SB:CastSpell(2643)
        end
    end
    if TB2Modes.Values[1]=="Single" then         
        --Chimera Shot
        if SB:CanCast("playertarget",53209,false) then
            return SB:CastSpell(53209)
        end

        --Serpent Sting
        if SB:CanCast("playertarget",1978,false) 
        and SB:Debuff("playertarget",true,GetSpellInfo(1978))==0 then
            return SB:CastSpell(1978)
        end

        --Aimed Shot
        if SB:CanCast("playertarget",19434,false) then
            return SB:CastSpell(19434)
        end
    end

    --Steady Shot
    if SB:CanCast("playertarget",56641,false) then
        return SB:CastSpell(56641)
    end
end
