function TBCanUse(key, target)
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
	
	if UnitIsDead(target) then
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


function TBCast(key,target)
	return IndicatorFrame.ByKey[key], target
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