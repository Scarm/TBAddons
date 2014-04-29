
DruidBalance = CreateSpec("DRUID","Balance","Interface\\Icons\\Spell_Arcane_Arcane03","Druid balance")

function DruidBalance:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")
end

function DruidBalance:OnInitSpells(SpellBinder)
    DruidBalance.time = 0

    --Wrath
    SpellBinder:RegisterSpell(5176)
    --Starfire
    SpellBinder:RegisterSpell(2912)
    --Starsurge
    SpellBinder:RegisterSpell(78674)
    --Moonfire
    SpellBinder:RegisterSpell(8921)
    --sun fire
    SpellBinder:RegisterSpell(93402)

end

function DruidBalance:OnInitButtons(SpellFrame)

end


function DruidBalance:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end

    local newDir = GetEclipseDirection()
    if DruidBalance.Dir~=newDir then
        print('direction changed for ',GetTime()-DruidBalance.time );
        DruidBalance.Dir = newDir
        DruidBalance.time = GetTime();
        DruidBalance.MFupd = 1
        DruidBalance.Wupd = 1
    end

    --[[
    local _,_,_,_,_,d,e = UnitDebuff("playertarget", 'Лунный огонь',nil,"PLAYER")
    if ( d~=nil )and( (e-d) > DruidBalance.time )and( DruidBalance.MFupd==1 ) then
        DruidBalance.MFupd = 0
        print('MF buffed')
    end
    local _,_,_,_,_,d,e = UnitDebuff("playertarget", 'Солнечный огонь',nil,"PLAYER")
    if ( d~=nil )and( (e-d) > DruidBalance.time )and( DruidBalance.MFupd==1 )   then
        DruidBalance.MFupd = 0
        print('MF buffed')
    end
    local _,_,_,_,_,d,e = UnitDebuff("playertarget", 'Рой насекомых',nil,"PLAYER")
    if ( d~=nil )and( (e-d) > DruidBalance.time )and( DruidBalance.Wupd==1 ) then
        DruidBalance.Wupd = 0
        print('W buffed')
    end
    --]]

    --Moonfire
    if SB:CanCast("playertarget",8921,false)
    and SB:Debuff("playertarget",true,GetSpellInfo(8921))<2
    and SB:Debuff("playertarget",true,GetSpellInfo(93402))<2 then
        return SB:CastSpell(8921)
    end

    --Insect Swarm
    if SB:CanCast("playertarget",93402,false)
    and SB:Debuff("playertarget",true,GetSpellInfo(93402))<2 then
        return SB:CastSpell(93402)
    end

    --[[
    --Moonfire
    if SB:CanCast("playertarget",8921,false)
    and DruidBalance.MFupd==1 then
        return SB:CastSpell(8921)
    end

    --Insect Swarm
    if SB:CanCast("playertarget",5570,false)
    and DruidBalance.Wupd==1 then
        return SB:CastSpell(5570)
    end
    --]]

    --Starsurge
    if SB:CanCast("playertarget",78674,false)
    and GetEclipseDirection()~='none' then
        return SB:CastSpell(78674)
    end

    --Wrath
    if SB:CanCast("playertarget",5176,false)
    and GetEclipseDirection()=='moon' then
        return SB:CastSpell(5176)
    end

    --Starfire
    if SB:CanCast("playertarget",2912,false)
    and ( GetEclipseDirection()=='sun' or GetEclipseDirection()=='none' ) then
        return SB:CastSpell(2912)
    end
end


DruidFeral = CreateSpec("DRUID","Feral","Interface\\Icons\\Ability_BullRush","Druid feral")

function DruidFeral:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")
end

function DruidFeral:OnInitSpells(SpellBinder)
    TB2Stress.RangeChecker = 33745
    --Growl
    SpellBinder:RegisterSpell(6795)
    --Faerie Fire
    SpellBinder:RegisterSpell(16857)
    --Maul
    SpellBinder:RegisterSpell(6807)
    --Lacerate
    SpellBinder:RegisterSpell(33745)
    --Mangle
    SpellBinder:RegisterSpell(33878)
    --Pulverize
    SpellBinder:RegisterSpell(80313)
    --Swipe
    SpellBinder:RegisterSpell(779)
    --Thrash
    SpellBinder:RegisterSpell(77758)
    --Skull Bash
    SpellBinder:RegisterSpell(80964)
    --Demoralizing Roar
    SpellBinder:RegisterSpell(99)

end

function DruidFeral:OnInitButtons(SpellFrame)

end

function DruidFeral:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if UnitIsPlayer("targettarget")==nil and UnitThreatSituation("player", "playertarget")==nil  then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end

    --Skull Bash
    if SB:CanInterrupt("playertarget",80964) then
        return SB:CastSpell(80964)
    end

    --Growl
    if SB:CanGetAgro("playertarget",6795) then
        return SB:CastSpell(6795)
    end


    if TB2Stress.Count>2 then
        --Swipe
        if SB:CanCast("playertarget",779,false,nil,33878) then
            return SB:CastSpell(779)
        end
        --Thrash
        if SB:CanCast("playertarget",77758,false,nil,33878) then
            return SB:CastSpell(77758)
        end

    end

    --Mangle
    if SB:CanCast("playertarget",33878) then
        return SB:CastSpell(33878)
    end

    --Pulverize
    if SB:CanCast("playertarget",80313)
    and SB:DebuffStacks("playertarget",true,GetSpellInfo(33745))==3 
    then
        return SB:CastSpell(80313)
    end 

    --Lacerate
    if SB:CanCast("playertarget",33745) then
        return SB:CastSpell(33745)
    end

    --Faerie Fire
    if SB:CanCast("playertarget",16857) then
        return SB:CastSpell(16857)
    end

    --Maul
    if SB:CanCast("playertarget",6807,false,80) then
        return SB:CastSpell(6807)
    end


end
