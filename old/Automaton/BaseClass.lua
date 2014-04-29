BaseClass = {} 

BaseClass.Lag = 130
BaseClass.Raid = Automaton.Raid

function BaseClass:Resolve(spellId)
    local _,_,offset,num = GetSpellTabInfo(2)
    local index = 0
    for index = offset+1, offset+num, 1 do
        local Type,Id = GetSpellBookItemInfo(index, "spell") 
        if spellId == Id then
            return index, "spell"
        end
    end 
    
    local petSpells = HasPetSpells()
    if petSpells then
        for index = 1, petSpells, 1 do
            local Type,Id = GetSpellBookItemInfo(index, "pet")
            if spellId == Id then
                return index, "pet"
            end
        end
    end  
end

function BaseClass:CanUseId(spellId,target)
    local caster = "player"
    local idx,book = self:Resolve(spellId)
      
    if UnitIsDead(caster) then
        return nil
    end
    
    if GetSpellCooldown(idx, book) ~= 0 then
        return nil
    end
    
    local isUsable = IsUsableSpell(idx, book)
    if isUsable ~= 1 then
        return nil
    end
           
    local et = select(6,UnitCastingInfo(caster)) or select(6, UnitChannelInfo(caster))
    if et and (et - self.Lag) > GetTime() * 1000 then 
        return nil
    end 

    
    --if IsSpellInRange(idx, book,target) then 
    if SpellHasRange(idx, book) then      
        
        if target == nil then
           --return nil
            return 1 --мы предполагаем, что есть цель не указана, значит не надо дела проверки на цель
        end

        if UnitCanAttack(caster, target) then
            
            if UnitIsDead(target) then
                return nil
            end
            
            if IsHarmfulSpell(idx, book) ~= 1 then
                return nil
            end

            if IsSpellInRange(idx, book, target) ~= 1 then
                return nil
            end
            return 1
        end
              
        if UnitCanAssist(caster, target) then
            if UnitIsDead(target) then
                return nil
            end
            
            if IsHelpfulSpell(idx, book) ~= 1 then
                return nil
            end                

            if IsSpellInRange(idx, book, target) ~= 1 then
                return nil
            end
            return 1
        end                
        
    else
        
        return 1
    end    
end

function BaseClass:CanUse(name, target)
    return self:CanUseId(self.Spells[name], target)
end

function BaseClass:Cast(name,target)
    return "spell", self.Spells[name], target
end

function BaseClass:Aura(name,isMine,target,mask,default)
    local spellId = self.Spells[name]
    local spellName = GetSpellInfo(spellId)
    if isMine then
        mask = mask.."|PLAYER"
    end    
    local stacks,_,_,et = select(4, UnitAura(target or default, spellName, nil, mask))
    if et and (et - GetTime()) > 0 then
        return et - GetTime(), stacks
    else
        return 0, 0
    end    
end

function BaseClass:Buff(name,isMine,target)   
    return self:Aura(name,isMine,target,"HELPFUL","player")
end

function BaseClass:Debuff(name,isMine,target)
    return self:Aura(name,isMine,target,"HARMFUL","target")
end

function BaseClass:BuffElapsed(name,isMine,target)
    local res = self:Buff(name,isMine,target)
    return res
end

function BaseClass:BuffStack(name,isMine,target)
    local _,res = self:Buff(name,isMine,target)
    return res
end

function BaseClass:DebuffElapsed(name,isMine,target)
    local res = self:Debuff(name,isMine,target)
    return res
end

function BaseClass:DebuffStack(name,isMine,target)
    local _,res = self:Debuff(name,isMine,target)
    return res
end


