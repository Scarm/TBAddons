RogueCombat = CreateSpec("ROGUE","Combat","Interface\\Icons\\Ability_BackStab","Rogue combat")

function RogueCombat:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
end

function RogueCombat:OnInitSpells(SpellBinder)
    TB2Stress.RangeChecker = 1752

    --Sinister Strike 
    SpellBinder:RegisterSpell(1752)
    --Slice and Dice 
    SpellBinder:RegisterSpell(5171) 
    --Revealing Strike
    SpellBinder:RegisterSpell(84617) 
    --Eviscerate
    SpellBinder:RegisterSpell(2098) 
    --Blade Flurry
    SpellBinder:RegisterSpell(13877) 
    --Kick
    SpellBinder:RegisterSpell(1766) 
    
end

function RogueCombat:OnInitButtons(SpellFrame)

end


function RogueCombat:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Stress.Count<2
    and SB:Buff("player",true,GetSpellInfo(13877))>0
    then
        return SB:CastSpell(13877)
    end  

    if TB2Modes.Values[0] =="StopAttack" then return end

    if UnitIsPlayer("targettarget")==nil 
    and UnitThreatSituation("player", "playertarget")==nil then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end



    if TB2Stress.Count>1
    and SB:Buff("player",true,GetSpellInfo(13877))==0
    and SB:CanCast("player",13877,nil,nil,1784)
    then
        return SB:CastSpell(13877)
    end

    --Kick
    if SB:CanInterrupt("playertarget",1766) then
        return SB:CastSpell(1766)
    end

    --Slice and Dice
    if SB:CanCast("player",5171,nil,nil,1784)
    and SB:Buff("player",true,GetSpellInfo(5171))==0
    and GetComboPoints("player","playertarget")>1 then
        return SB:CastSpell(5171)
    end

    --Eviscerate
    if SB:CanCast("player",2098,nil,nil,1752)
    and GetComboPoints("player","playertarget")>3 then 
        return SB:CastSpell(2098)
    end

    --Revealing Strike
    if SB:CanCast("playertarget",84617,nil,80)
    and SB:Buff("player",true,GetSpellInfo(5171))>0
    and SB:Debuff("playertarget",true,GetSpellInfo(84617))==0 
    then
        return SB:CastSpell(84617)
    end

    --Sinister Strike
    if SB:CanCast("playertarget",1752,nil,80) then
        return SB:CastSpell(1752)
    end
end


RogueSubtlety = CreateSpec("ROGUE","Subtlety","Interface\\Icons\\Ability_Stealth","Rogue subtlety")

function RogueSubtlety:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
end

function RogueSubtlety:OnInitSpells(SpellBinder)

end

function RogueSubtlety:OnInitButtons(SpellFrame)

end

function RogueSubtlety:OnUpdate()

end
