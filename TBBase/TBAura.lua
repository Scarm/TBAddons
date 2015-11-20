function BaseGroupHelper:ParseAuraParams(...)
	local result = {}
	--перечисляем все параметры
	local params = select("#", ...)
	for i = 1,params,1 do
		local val = select(i, ...)
		if val == "mine" then 
			result.isMine = 1
		end
		if val == "self" then 
			result.isSelf = 1
		end
		if val == "inverse" then 
			result.inverse = 1
		end
		
		if type(val) == "table" then
			if val.left then
				result.left = val.left
			end
			
			if val.stacks then
				result.stacks = val.stacks
			end
			
			if val.skip then
				result.skip = val.skip
			end			
		end
	end
	-- если не указано - считаем за 0
	result.skip = result.skip or 0
	
	return result
end

function BaseGroupHelper:UnitHasAuraMask(target, spellID, params, mask)
	for i=1,40,1 do
		-- проверяем, тот ли у нас спелл
		local id = select(11, UnitAura(target, i, mask))
		if id and id == spellID then
			-- время завершения спелла
			local et = select(7, UnitAura(target, i, mask))
			-- et == 0 для спеллов без времени окончания действия
			local cond = nil
			--аура постоянного действия
			if et == 0 then
				cond = 1
			end
			
			if params.left then
				if GetTime() > et - params.left then 
					cond = 1
				end
			else
				if GetTime() < et - params.skip then 
					cond = 1
				end
			end

			if cond then
				-- если указано требование к количеству стаков - считаем их количество
				if params.stacks then
					
					local stacks = select(4, UnitAura(target, i, mask))
					if  stacks >= params.stacks then
						return 1
					else
						return nil
					end
				else
					return 1
				end
			end
		end
	end
end

function BaseGroupHelper:UnitHasAura(target, spellIDs, params)
	--если аура должна быть обязательно наложена кастером - добавляем в маску фильтр
	local mask = ""
	if params.isMine then
		mask = "|PLAYER"
	end
	local result = nil
	for key, id in pairs(spellIDs) do
		result = result or BaseGroupHelper:UnitHasAuraMask(target, id, params, "HELPFUL"..mask) or BaseGroupHelper:UnitHasAuraMask(target, id, params, "HARMFUL"..mask)
	end
	
	return result
end

function BaseGroup:Aura(spellKey, ...)
	if type(spellKey) == "nil" then
		--возвращаем nil, это приведет к очевидной ошибке в lua
		--если возвращать result - тогда будет не очевидно, что мы вышли по явной ошибке
		return nil
	end
	if type(spellKey) == "string" then
		spellKey = {spellKey}
	end
	
	local spellIDs = {}
	for k,v in pairs(spellKey) do
		local id = IndicatorFrame.Spec.Buffs[v] or IndicatorFrame.Spec.Spells[v]
		if id == nil then
			--возвращаем nil, это приведет к очевидной ошибке в lua
			--если возвращать result - тогда будет не очевидно, что мы вышли по явной ошибке
			return nil
		end
		spellIDs[v] = id
	end

	--извлекаем параметры
	local params = BaseGroupHelper:ParseAuraParams(...)
		
	local result = self:CreateDerived()
	
	if params.isSelf then
		local hasAura = BaseGroupHelper:UnitHasAura("player", spellIDs, params)
		if (hasAura==1) == not (params.inverse==1) then
			return self
		else
			return result
		end
	else
		for key,value in pairs(self) do
			local hasAura = BaseGroupHelper:UnitHasAura(key, spellIDs, params)
			if (hasAura==1) == not (params.inverse==1)  then
				result[key] = value
			end
		end	
	end
	
	return result
end