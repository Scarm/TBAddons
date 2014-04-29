
WarProt = CreateSpec("WARRIOR","Prot","Interface\\Icons\\Ability_Warrior_DefensiveStance","Protection warrior")
WarArms = CreateSpec("WARRIOR","Arms","Interface\\Icons\\Ability_Warrior_SavageBlow","Arms warrior")

function WarProt:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(4,"Interface\\Icons\\Ability_Warrior_RallyingCry","Command","коммандирский крик")
    Modes:AddMode(4,"Interface\\Icons\\Ability_Warrior_BattleShout","Battle","боевой крик")
end


function WarProt:OnInitSpells(SpellBinder)
    TB2Stress.RangeChecker = 23922
    --Pummel
    SpellBinder:RegisterSpell(6552)
    --Taunt
    SpellBinder:RegisterSpell(355)
    --Rend
    SpellBinder:RegisterSpell(772)
    --Heroic Strike
    SpellBinder:RegisterSpell(78)
    --Devastate
    SpellBinder:RegisterSpell(20243)
    --Revenge
    SpellBinder:RegisterSpell(6572)
    --Shield Slam
    SpellBinder:RegisterSpell(23922)
    --Thunder Clap
    SpellBinder:RegisterSpell(6343)
    --Battle Shout
    SpellBinder:RegisterSpell(6673)
    --Commanding Shout
    SpellBinder:RegisterSpell(469)
    --Victory Rush
    SpellBinder:RegisterSpell(34428)

end

function WarProt:OnInitButtons(SpellFrame)

end

function WarProt:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    if UnitIsPlayer("targettarget")==nil and UnitThreatSituation("player", "playertarget")==nil  then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end


    --Pummel
    if SB:CanInterrupt("playertarget",6552) then
        return SB:CastSpell(6552)
    end

    --Taunt
    if SB:CanGetAgro("playertarget",355) then
        return SB:CastSpell(355)
    end


    if TB2Stress.Count>2 then
        --Thunder Clap
        if SB:CanCast("playertarget",6343,false,nil,23922) then
            return SB:CastSpell(6343)
        end
    end

    --Shield Slam
    if SB:CanCast("playertarget",23922) then
        return SB:CastSpell(23922)
    end

    --Victory Rush
    if SB:CanCast("playertarget",34428) then
        return SB:CastSpell(34428)
    end

    --Rend
    if SB:CanCast("playertarget",772)
    and SB:Debuff("playertarget",true,GetSpellInfo(772))==0 then
        return SB:CastSpell(772)
    end

    --Revenge
    if SB:CanCast("playertarget",6572)
    and UnitPower("player")<30 then
        return SB:CastSpell(6572)
    end

    --Battle Shout
    if SB:CanCast("player",6673)
    and TB2Modes.Values[4]=="Battle"
    and UnitAffectingCombat("player") then
        return SB:CastSpell(6673)
    end

    --Commanding Shout
    if SB:CanCast("player",469)
    and TB2Modes.Values[4]=="Command"
    and UnitAffectingCombat("player") then
        return SB:CastSpell(469)
    end

    --Thunder Clap
    if SB:CanCast("playertarget",6343,false,nil,23922)
    and SB:Debuff("playertarget",true,GetSpellInfo(6343))==0 then
        return SB:CastSpell(6343)
    end

    --Devastate
    if SB:CanCast("playertarget",20243)
    then
        return SB:CastSpell(20243)
    end 

    --Heroic Strike
    if SB:CanCast("playertarget",78,false,75) then
        return SB:CastSpell(78)
    end

end


function WarArms:OnInitModes(Modes)
    Modes:AddMode(0,"Interface\\Icons\\Ability_BullRush","IgnoreAgro","Не обращать внимания на агро")
    Modes:AddMode(0,"Interface\\Icons\\Ability_Druid_Cower","ArgoStop","Прекращать ДПС при высоком агро")
    Modes:AddMode(0,"Interface\\Icons\\ABILITY_SEAL","StopAttack","Прекратить ДПС")

    Modes:AddMode(4,"Interface\\Icons\\Ability_Warrior_RallyingCry","Command","коммандирский крик")
    Modes:AddMode(4,"Interface\\Icons\\Ability_Warrior_BattleShout","Battle","боевой крик")
end

function WarArms:OnInitSpells(SpellBinder)
    TB2Stress.RangeChecker = 23922
    --Pummel
    SpellBinder:RegisterSpell(6552)
    --Rend
    SpellBinder:RegisterSpell(772)
    --Heroic Strike
    SpellBinder:RegisterSpell(78)
    --Cleave
    SpellBinder:RegisterSpell(845)	
	
    --Mortal Strike
    SpellBinder:RegisterSpell(12294)		
    --Colossus Smash
    SpellBinder:RegisterSpell(86346)	
    --Overpower
    SpellBinder:RegisterSpell(7384)	
    --Slam
    SpellBinder:RegisterSpell(1464)	
    --Execute
    SpellBinder:RegisterSpell(5308)	

	--Hamstring
    SpellBinder:RegisterSpell(1715)
	
    --Battle Shout
    SpellBinder:RegisterSpell(6673)
    --Commanding Shout
    SpellBinder:RegisterSpell(469)
	--Victory Rush
    SpellBinder:RegisterSpell(34428)
end

function WarArms:OnInitButtons(SpellFrame)

end

function WarArms:OnUpdate(SB)
    if IsMounted() then return end

    if TB2Modes.Values[0] =="StopAttack" then return end

    --if UnitIsPlayer("targettarget")==nil and UnitThreatSituation("player", "playertarget")==nil  then return end

    if TB2Modes.Values[0] =="ArgoStop"
    and (UnitThreatSituation("player", "playertarget") or 0) > 0 then return end


    --Pummel
    if SB:CanInterrupt("playertarget",6552) then
        return SB:CastSpell(6552)
    end
	
	--Victory Rush
    if SB:CanCast("playertarget",34428)
		and UnitHealth("player")<0.8*UnitHealthMax("player")  then
        return SB:CastSpell(34428)
    end
	
    --Hamstring
    if SB:CanCast("playertarget",1715)
	and UnitIsPlayer("playertarget")
    and SB:Debuff("playertarget",true,GetSpellInfo(1715))==0 then
        return SB:CastSpell(1715)
    end

    --Hamstring
    if SB:CanCast("playertarget",1715)
	and UnitName("playertarget")=="Боевой разрушитель"
    and SB:Debuff("playertarget",true,GetSpellInfo(1715))==0 then
        return SB:CastSpell(1715)
    end	
	
    --Mortal Strike
    if SB:CanCast("playertarget",12294) then
        return SB:CastSpell(12294)
    end

    --Rend
    if SB:CanCast("playertarget",772)
    and SB:Debuff("playertarget",true,GetSpellInfo(772))==0
	and SB:Debuff("playertarget",true,GetSpellInfo(86346))==0	then
        return SB:CastSpell(772)
    end
	
    --Colossus Smash
    if SB:CanCast("playertarget",86346)
    and SB:Debuff("playertarget",true,GetSpellInfo(86346))==0 then
        return SB:CastSpell(86346)
    end
	
    --Execute
    if SB:CanCast("playertarget",5308) then
        return SB:CastSpell(5308)
    end		
	
    --Overpower
    if SB:CanCast("playertarget",7384) then
        return SB:CastSpell(7384)
    end	

    --Slam
    if SB:CanCast("playertarget",1464) then
        return SB:CastSpell(1464)
    end		
	
    --Battle Shout
    if SB:CanCast("player",6673)
    and TB2Modes.Values[4]=="Battle"
    and UnitAffectingCombat("player") then
        return SB:CastSpell(6673)
    end

    --Commanding Shout
    if SB:CanCast("player",469)
    and TB2Modes.Values[4]=="Command"
    and UnitAffectingCombat("player") then
        return SB:CastSpell(469)
    end

	if TB2Stress.Count>2 then
        --Cleave
        if SB:CanCast("playertarget",845) then
            return SB:CastSpell(845)
        end
	else
		--Heroic Strike
		if SB:CanCast("playertarget",78,false,85) then
			return SB:CastSpell(78)
		end			
    end		

end
