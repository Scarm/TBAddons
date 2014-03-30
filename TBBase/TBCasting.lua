function TBPartyList()
	result = {}
	
	if IsInRaid() then
		for i = 1, GetNumGroupMembers(), 1 do
			result["raid"..i] = {}
		end		
	elseif IsInGroup() then
		result["player"] = {}
		for i = 1, GetNumGroupMembers() - 1, 1 do
			result["party"..i] = {}
		end
	else
		result["player"] = {}
	end

	return result
end

function TBCanUseSingle(key, target)
	local spell = IndicatorFrame.ByKey[key]
	if spell == nil then
		print("НЕ НАЙДЕН СПЕЛЛ! ", key)
		return nil
	end
	
    local caster = "player"
    local idx = spell.TabIndex
	local book = spell.Type

	if target == nil then 
		return nil
	end
	
    if UnitIsDead(caster) then
        return nil
    end
	  
    if GetSpellCooldown(idx, book) ~= 0 then
        return nil
    end
    
    if IsUsableSpell(idx, book) == nil then
        return nil
    end
           
    local et = select(6,UnitCastingInfo(caster)) or select(6, UnitChannelInfo(caster))
    if et and et > GetTime() * 1000 then 
        return nil
    end
	
	if UnitIsDead(target) then
		return nil
	end

	if SpellHasRange(idx, book) and  IsSpellInRange(idx, book, target) == nil then
		return nil
	end 
		
	if UnitCanAttack(caster, target) and IsHarmfulSpell(idx, book) then
		return 1
	end

		  
	if UnitCanAssist(caster, target) and IsHelpfulSpell(idx, book) then
		return 1
	end

	-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
	if IsHarmfulSpell(idx, book)==nil and IsHelpfulSpell(idx, book)==nil then
		return 1
	end
	
	return nil	
end

function TBCheckTarget(target, idx, book, caster)
	if UnitIsDead(target) then
		return nil
	end
	
	if SpellHasRange(idx, book) and  IsSpellInRange(idx, book, target) == 0 then
		return nil
	end 
		
	if UnitCanAttack(caster, target) and IsHarmfulSpell(idx, book) then
		return 1
	end

		  
	if UnitCanAssist(caster, target) and IsHelpfulSpell(idx, book) then
		return 1
	end

	-- Спелл можно кидать и в своих и в чужих, тогда разрешаем кидать, ответственность на составителе бота
	if IsHarmfulSpell(idx, book)==nil and IsHelpfulSpell(idx, book)==nil then
		return 1
	end
	
	return nil

end

function TBCanUseMulti(key, target)
	local result = {}
	
	if target == nil or type(target)~="table" then 
		print("ПЕРЕДАН НЕ СПИОК ЦЕЛЕЙ!")
		return result
	end

	local spell = IndicatorFrame.ByKey[key]
	if spell == nil then
		print("НЕ НАЙДЕН СПЕЛЛ! ", key)
		return result
	end
	
    local caster = "player"
    local idx = spell.TabIndex
	local book = spell.Type

    if UnitIsDead(caster) then
        return result
    end
	  
    if GetSpellCooldown(idx, book) ~= 0 then
        return result
    end
    
    if IsUsableSpell(idx, book) == nil then
        return result
    end
           
    local et = select(6,UnitCastingInfo(caster)) or select(6, UnitChannelInfo(caster))
    if et and et > GetTime() * 1000 then 
        return result
    end
	
	for key,value in pairs(target) do
		if TBCheckTarget(key, idx, book, caster) then
			result[key] = value
		end	
	end
	
	return result		
end

function TBCanUse(key, target)
	if type(target) == "table" then
		return TBCanUseMulti(key, target)
	else
		return TBCanUseSingle(key, target)
	end
end


function TBCast(key,target)
	return IndicatorFrame.ByKey[key].BaseName
end


function TBHasAura(spell,isMine,targets,mask,limit)
    result = {}
	if spell == nil then
		return result
	end
	
	if isMine then
        mask = mask.."|PLAYER"
    end 

	
	for target,value in pairs(targets) do
		local etBase = select(7, UnitAura(target, spell.BaseName, nil, mask))
		local etReal = select(7, UnitAura(target, spell.RealName, nil, mask))
		local et = etBase or etReal
		
		if et and ((et == 0) or (et - GetTime() > limit)) then
			
		else
			result[target] = value
		end 		
	end
	return result
end

function TBHasBuff(name,isMine,target, limit)
    return TBHasAura(IndicatorFrame.ByKey[name],isMine,target,"HELPFUL", limit or 0)
end

function TBAura(spell,isMine,target,mask)
    if spell == nil then
		--print("spell == nil")
		return nil,nil
	end
	
	if isMine then
        mask = mask.."|PLAYER"
    end    
    local stacksBase,_,_,etBase = select(4, UnitAura(target, spell.BaseName, nil, mask))
    local stacksReal,_,_,etReal = select(4, UnitAura(target, spell.RealName, nil, mask))
    local et = etBase or etReal
	local stacks = stacksBase or stacksReal
	
	if et then
		if et == 0 then
			return 0, stacks
		else 
			return et - GetTime(), stacks
		end
    else
        return nil, nil	
	end  
end

function TBCanInterrupt(target)
	if target == nil then
		return nil
	end

	local casting = UnitCastingInfo(target) or UnitChannelInfo(target)
	local notInterrupt = select(9,UnitCastingInfo(target)) or select(9,UnitChannelInfo(target))
	if casting and notInterrupt == nil then
		return 1
	end
	return nil
end

function TBSpellCharges(name)
	return GetSpellCharges(IndicatorFrame.ByKey[name].BaseId)
end 

function TBBuff(name,isMine,target)
    return TBAura(IndicatorFrame.ByKey[name],isMine,target,"HELPFUL")
end

function TBDebuff(name,isMine,target)
    return TBAura(IndicatorFrame.ByKey[name],isMine,target,"HARMFUL")
end

function TBBuffElapsed(name,isMine,target)
    local res = TBBuff(name,isMine,target)
    return res
end

function TBBuffStack(name,isMine,target)
    local _,res = TBBuff(name,isMine,target)
    return res
end

function TBDebuffElapsed(name,isMine,target)
    local res = TBDebuff(name,isMine,target)
    return res
end

function TBDebuffStack(name,isMine,target)
    local _,res = TBDebuff(name,isMine,target)
    return res
end

function TBLastCast(key)
	if IndicatorFrame.LastSpellTime == nil then
		IndicatorFrame.LastSpellTime = 0
	end
	
	if GetTime() > IndicatorFrame.LastSpellTime then
		IndicatorFrame.LastSpell = nil
	end

	if IndicatorFrame.LastSpell and IndicatorFrame.LastSpell.Key == key then
		return 1
	end	
	
	return nil
end