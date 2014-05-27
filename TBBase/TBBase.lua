function TBRegister(bot)
	if bot == nil then
		print("Передан пустой бот")
	end
	
	if bot.Class == nil then
		print("Не задан класс бота")
	end
	
	if bot.Id == nil then
		print("Не задан спек бота")
	end
	
	if bot.OnUpdate ==nil then
		print("Не задана функция OnUpdate")
	end
	
	if IndicatorFrame.Bots == nil then
		IndicatorFrame.Bots = {}
	end
	
	if IndicatorFrame.Bots[bot.Class] == nil then
		IndicatorFrame.Bots[bot.Class] = {}
	end
	
	if IndicatorFrame.Bots[bot.Class][bot.Id] ~= nil then
		print("Повторная регистрация бота для Class = ", bot.Class," и спека = ",bot.Id)
		return
	end
	
	print("Регистрируем бота для Class = ", bot.Class," и спека = ",bot.Id)
	IndicatorFrame.Bots[bot.Class][bot.Id] = bot
end


function TBOnPlayerLogin(self)
	TBCreateIndicators(self)
	TBCreatePanel()
	TBAssignBot(self)
end

function TBAssignBot(self)
	if IsLoggedIn() == nil then
		return
	end
	-- бота чистим всегда, а устанавливаем - только если нашли подходящего
	TBClearSpec()
	TBClearPanel()
	
    local name,class = UnitClass("player")
    print("Загружаются боты для класса",name)
    --self:InitSavedVariables()   
    if IndicatorFrame.Bots[class] == nil then
        print("Не обнаружено ботов для этого класса")
        return
    end

    local currentTalents = GetSpecialization()
	if IndicatorFrame.Bots[class][currentTalents] == nil then
		print("Не обнаружено ботов для этого спека")
        return
	end
	
	TBInitPanel()
	return TBSetSpec(IndicatorFrame.Bots[class][currentTalents])
end

-- очистить текущий спек
function TBClearSpec()
    print("ClearSpec") 
    IndicatorFrame.Spec = nil
    TBUnregisterAllSpells()
		
	IndicatorFrame.ByName = {}
	IndicatorFrame.ById = {}
	IndicatorFrame.ByKey = {}
	

	IndicatorFrame.Enemies = {}
	IndicatorFrame.EnemyCount = 0
    --self.Panel:RemoveAllButtons()    
end

-- устанавливаем спек:
-- регистрируем нужные спеллы и кнопки, присваиваем поле Spec
function TBSetSpec(spec)
    print("SetSpec ",spec.Id)
    IndicatorFrame.Spec = spec
    TBCreateSpellMaps()
	
    for key,spell in pairs(IndicatorFrame.ById) do
        if spell.IsSpell then
			TBRegisterSpell(spell.BaseName)
		end
    end
end

function TBCreateSpellMaps()
	if IsLoggedIn() == nil then
		return
	end
	
	if IndicatorFrame.Spec == nil then
		return
	end
	
	print("TBCreateSpellMaps")

	IndicatorFrame.ByName = {}
	IndicatorFrame.ById = {}
	IndicatorFrame.ByKey = {}
	
	for name, id in pairs(IndicatorFrame.Spec.Spells) do
		spell = {}
		spell.IsSpell = 1
		spell.Key = name
		
		spell.BaseId = id
		spell.BaseName = GetSpellInfo(spell.BaseId)
		spell.RealId = id
		spell.RealName = GetSpellInfo(spell.RealId)
		
		IndicatorFrame.ByName[spell.RealName] = spell		
		IndicatorFrame.ById[spell.RealId] = spell		
		IndicatorFrame.ByKey[name] = spell
	end
	
	for name, id in pairs(IndicatorFrame.Spec.Buffs) do
		spell = {}

		spell.BaseId = id
		spell.BaseName = GetSpellInfo(spell.BaseId)
		spell.RealId = id
		spell.RealName = GetSpellInfo(spell.RealId)
		
		IndicatorFrame.ByName[spell.RealName] = spell		
		IndicatorFrame.ById[spell.RealId] = spell		
		IndicatorFrame.ByKey[name] = spell
	end	
	
	local _,_,offset,num = GetSpellTabInfo(2)
    for index = offset+1, offset+num, 1 do
		local Type,baseId = GetSpellBookItemInfo(index, "spell")
		local link = GetSpellLink(index, "spell")
		local realId = baseId
		if link then
			realId = tonumber(link:match("spell:(%d+)"))
		else
			realId = nil
		end

        local spell = IndicatorFrame.ById[baseId] or IndicatorFrame.ById[realId]
		if spell then
			spell.Type = "spell"
			spell.TabIndex = index
			spell.BaseId = baseId
			spell.BaseName = GetSpellInfo(spell.BaseId)
			spell.RealId = realId
			spell.RealName = GetSpellInfo(spell.RealId)
			
			IndicatorFrame.ByName[spell.BaseName] = spell		
			IndicatorFrame.ById[spell.BaseId] = spell
			IndicatorFrame.ByName[spell.RealName] = spell		
			IndicatorFrame.ById[spell.RealId] = spell
		end
    end
	
	--[[
	print("spell enumeration begin")
	for key, spell in pairs(IndicatorFrame.ByKey) do
		print(key ,spell.TabIndex, spell.Type, spell.BaseId, spell.BaseName, spell.RealId, spell.RealName, spell.IsSpell)
	end	
	print("spell enumeration end")
	--]]
	
end

function TBOnUpdate()
	
	TBClearControls()	
	if IndicatorFrame.Spec then
		local player, party, focus, targets = TBGroups()
		local cmd = IndicatorFrame.Spec:OnUpdate(player, party, focus, targets, TBList(), PanelFrame.Groups)
		if cmd then
			IndicatorFrame.LastCommand = cmd
		end
		TBCommand(cmd)
	end
end

function TBLastCastUpdate(self, event,...)
	local unitId,_,_,lineId,spellId = select(1,...)
	-- Если колдовали мы
	if unitId=="player" then	
		local spell = IndicatorFrame.ById[spellId]	
		-- И спелл, за которым надо следить
		if spell then
			IndicatorFrame.LastSpell = spell
		
			local et = select(6,UnitCastingInfo("player")) or select(6, UnitChannelInfo("player"))
			if et then
				IndicatorFrame.LastSpellTime = (et/1000) + 1 -- время окончания плюс секунда
			else
				IndicatorFrame.LastSpellTime = GetTime() + 1
			end
		end
	end
end

function TBLastCastUpdateFailed(self, event,...)
	local unitId,_,_,lineId,spellId = select(1,...)
	if unitId=="player" then	
		IndicatorFrame.LastSpell = nil
	end
	--print(event, GetSpellInfo(spellId))
end

function TBCombatLog(self, event,timestamp, combatevent,...)
	if combatevent == "UNIT_DIED" then
		local guid = select(6,...)
		IndicatorFrame.Enemies[guid] = nil
		
		IndicatorFrame.EnemyCount = 0
		for _ in pairs(IndicatorFrame.Enemies) do IndicatorFrame.EnemyCount = IndicatorFrame.EnemyCount + 1 end
	end
end

function TBMouseOver()
	local goodTarget = UnitIsDead("mouseover")==nil 
		and UnitCanAttack("player", "mouseover") 
		and IsSpellInRange("Удар воина Света", "mouseover") == 1 
		and UnitAffectingCombat("mouseover")

	if goodTarget then
		IndicatorFrame.Enemies[UnitGUID("mouseover")] = GetUnitName("mouseover")
	else
		IndicatorFrame.Enemies[UnitGUID("mouseover")] = nil
	end
	
	IndicatorFrame.EnemyCount = 0
	for _ in pairs(IndicatorFrame.Enemies) do IndicatorFrame.EnemyCount = IndicatorFrame.EnemyCount + 1 end
end

