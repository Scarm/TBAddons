ShamanElem = CreateSpec("SHAMAN","Elemental","Interface\\Icons\\Spell_Nature_Lightning","Elemental Shaman")

function ShamanElem:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
end

function ShamanElem:OnInitSpells(SpellBinder)
    --Lava Burst
    SpellBinder:RegisterSpell(51505)
    --Flame Shock
    SpellBinder:RegisterSpell(8050)
    --Lightning Bolt
    SpellBinder:RegisterSpell(403)
    --Lightning Shield
    SpellBinder:RegisterSpell(324)
end

function ShamanElem:OnInitButtons(SpellFrame)

end


function ShamanElem:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end

    --Lightning Shield
    if SB:CanCast("player",324)
    and SB:Buff("player",true,GetSpellInfo(324))==0 then
        return SB:CastSpell(324)
    end

    --Flame Shock
    if SB:CanCast("playertarget",8050,false)
    and SB:Debuff("playertarget",true,GetSpellInfo(8050))==0 then
        return SB:CastSpell(8050)
    end

    --Lava Burst
    if SB:CanCast("playertarget",51505,false) then
        return SB:CastSpell(51505)
    end

    --Lightning Bolt
    if SB:CanCast("playertarget",403,false) then
        return SB:CastSpell(403)
    end
end

ShamanRestor = CreateSpec("SHAMAN","Restoration","Interface\\Icons\\Spell_Nature_HealingWaveGreater","Restoration Shaman")

function ShamanRestor:OnInitModes(Modes)

end

function ShamanRestor:OnInitSpells(SpellBinder)
    --Water Shield
    SpellBinder:RegisterSpell(52127)
end

function ShamanRestor:OnInitButtons(SpellFrame)

end


function ShamanRestor:OnUpdate(SB)
    if IsMounted() then return end

    if SB:CanCast("player",52127)
    and SB:Buff("player",true,GetSpellInfo(52127))==0 then
        return SB:CastSpell(52127)
    end

end
