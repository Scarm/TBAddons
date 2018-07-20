function BaseGroupHelper:ParseAuraParams(...)
	local result = {}
	TBLogValues["stacks filled"] = nil

	result.time = 0
	result.timeBound = ">"
	result.stacks = 0
	result.stacksBound = ">"

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
			if val.stacks then
				result.stacks = val.stacks
				result.stacksBound = val.bound
				TBLogValues["stacks filled"] = 1
			end

			if val.time then
				result.time = val.time
				result.timeBound = val.bound
			end

			if val.left then
				print("ERROR: found lagacy param <left>")
			end
			if val.skip then
				print("ERROR: found lagacy param <skip>")
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
		local id = select(10, UnitAura(target, i, mask))
		if id and id == spellID then
			-- время завершения спелла
			local et = select(6, UnitAura(target, i, mask))
			-- et == 0 для спеллов без времени окончания действия
			local cond = nil
			--аура постоянного действия
			if et == 0 then
				cond = 1
			end

			local t = et - GetTime()
			if (params.timeBound == "<" and t <= params.time) or (params.timeBound == ">" and t >= params.time) then
				cond = 1
			end

			if cond then
				-- если указано требование к количеству стаков - считаем их количество
				local stacks = select(3, UnitAura(target, i, mask)) or 0
				TBLogValues["stacks count"] = stacks
				TBLogValues["stacks condition"] = params.stacks
				TBLogValues["stacks bound"] = params.stacksBound

				if (params.stacksBound == "<" and stacks <= params.stacks) or (params.stacksBound == ">" and stacks >= params.stacks) then
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
	--TBLogValues["aura"] = "init"
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
		local id = IndicatorFrame.Spec.Buffs[v] or IndicatorFrame.Spec.Spells[v] or IndicatorFrame.PlainBuffs[v]
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
		--TBLogValues["aura"] = "self"
		local hasAura = BaseGroupHelper:UnitHasAura("player", spellIDs, params)
		--TBLogValues["aura"] = hasAura
		if (hasAura==1) == not (params.inverse==1) then
			return self
		else
			return result
		end
	else
		--TBLogValues["aura"] = "other"
		for key,value in pairs(self) do
			local hasAura = BaseGroupHelper:UnitHasAura(key, spellIDs, params)
			if (hasAura==1) == not (params.inverse==1)  then
				result[key] = value
			end
		end
	end

	return result
end
