print("TBBase.lua")

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
	
	--print("Регистрируем бота для Class = ", bot.Class," и спека = ",bot.Id)
	IndicatorFrame.Bots[bot.Class][bot.Id] = bot
end


function TBOnPlayerLogin(self)
	print("OnLogin")
	TBCreateIndicators(self)
	TBCreatePanel(self)
	TBAssignBot(self)
	
	if IndicatorFrame.LoS == nil then
		IndicatorFrame.LoS = {}
		IndicatorFrame.LoS.Banned = {}
	end
end

function TBAssignBot(self)
	if IsLoggedIn() == false then
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
	
	TBInitPanel(IndicatorFrame.Bots[class][currentTalents])
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

TBBagActions = {}


function TBMacroCommands()
	--TBSetMacro("/cast Измельчение\n/use Награндский стрелоцвет")

	if TBBagActions.Milling then
		local Herbs = {}
		Herbs["Морозноцвет"] = 0
		Herbs["Таладорская орхидея"] = 0
		Herbs["Пламецвет"] = 0
		Herbs["Звездоцвет"] = 0
		Herbs["Награндский стрелоцвет"] = 0
		Herbs["Горгрондская мухоловка"] = 0
	
		for bag = 0,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				local _,count = GetContainerItemInfo(bag, slot)
				if id then
					local name = GetItemInfo(id)
					if Herbs[name] then
						Herbs[name] = Herbs[name] + count
					end
				end
			end
		end
		
		local macrotext = "/cast Измельчение\n/use "
		
		TBBagActions.Milling = nil
		for k,v in pairs(Herbs) do
			if v > 200 then
				macrotext = macrotext..k
				TBSetMacro(macrotext)
				TBBagActions.Milling = 1
				return "macro"
			end
		end
		
	end
	
	if TBBagActions.Salvage then

		for bag = 1,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				local _,count = GetContainerItemInfo(bag, slot)
				if id then
					local name,_,quality, ilvl = GetItemInfo(id)
					local itemSpell = GetItemSpell(id)
					local equipSlot = select(9, GetItemInfo(id))
					
					if quality == 0 then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					if quality == 2 and equipSlot and equipSlot~="" and equipSlot~="INVTYPE_BAG" then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					if quality == 3 and ilvl < 500 and equipSlot and equipSlot~="" and equipSlot~="INVTYPE_BAG" then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
				end
			end
		end
	
		TBBagActions.Salvage = nil
		local macrotext = "/use "
		for bag = 0,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				if id then
					local name = GetItemInfo(id)
					if (name == "Большой ящик для утиля" or name == "Сумка с утилем" or name == "Ящик для утиля") and TBBagActions.Salvage == nil  then
						macrotext = macrotext.. name
						TBSetMacro(macrotext)
						TBBagActions.Salvage = 1
					end
				end
			end
		end
		return "macro"
	end
	
	--[[
		print("sell list:")
		for bag = 1,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				local _,count = GetContainerItemInfo(bag, slot)
				if id then
					local name,_,quality, ilvl = GetItemInfo(id)
					local itemSpell = GetItemSpell(id)
					local equipSlot = select(9, GetItemInfo(id))
					
					if quality == 0 then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					if (quality == 2 or quality == 3) and ilvl < 500 and equipSlot and equipSlot~="" then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					--if ilvl > 500 and (quality == 2 or quality == 3) and itemSpell == nil then
					--	print(name, quality, ilvl)
					--end
				end
			end
		end
		TBBagActions.Sell = nil
	end	
	--]]
	
end

function TBOnUpdate()
	
	--TBClearControls()	
	if IndicatorFrame.Spec then
		local cmd = IndicatorFrame.Spec:OnUpdate(TBGroups(), TBList(), PanelFrame.Groups) or TBMacroCommands()
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
				IndicatorFrame.LastSpellTime = (et/1000) + 2 -- время окончания плюс секунда
			else
				IndicatorFrame.LastSpellTime = GetTime() + 2
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

function TBLastCastData(self, event,...)
	if (select(1,...) == "player") then
		IndicatorFrame.LoS.SpellName = select(2,...)
		IndicatorFrame.LoS.targetName = select(4,...)
   end
end

function TBLoSdetect(self, event,...)
	if (select(2,...) == "SPELL_CAST_FAILED") 
	and (select(5,...) == UnitName("player")) 
	and (select(15,...) == SPELL_FAILED_LINE_OF_SIGHT)
	and (select(13,...) == IndicatorFrame.LoS.SpellName) then
		print(IndicatorFrame.LoS.targetName)	
		IndicatorFrame.LoS.Banned[IndicatorFrame.LoS.targetName] = GetTime()
	end
end
--[[
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
--]]

function TBEnterCombat() 
	IndicatorFrame.InCombat = 1	
end

function TBLeaveCombat() 
	IndicatorFrame.InCombat = nil	
end

--[[
function TBAuction()
	print("TBAuction")
	
	SortAuctionClearSort("list")
	SortAuctionSetSort("list", "buyout")
	SortAuctionApplySort("list")
	QueryAuctionItems("Символ боя насмерть")
end

function TBOnAuctionListUpdate()
	print("TBOnAuctionListUpdate")
	print(GetAuctionItemInfo("list", 1))
end

TBStatistic = {}
TBStatistic.Value = 0

function TBStatisticFunc(self, event, ...)
	
	local curr = GetTime()
	if TBStatistic.prev == nil then
		TBStatistic.sum = 0
		TBStatistic.count = 0
		TBStatistic.Value = 0
	else
		local val = curr - TBStatistic.prev
		TBStatistic.sum = TBStatistic.sum + val
		TBStatistic.count = TBStatistic.count + 1
		TBStatistic.Value = TBStatistic.sum / TBStatistic.count
	end
	TBStatistic.prev = curr
	
	print(TBStatistic.Value,"(",TBStatistic.sum, "/" ,TBStatistic.count,")" )
end
--]]









