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
	
	IndicatorFrame.Bots = IndicatorFrame.Bots or {}
	IndicatorFrame.Bots[bot.Class] = IndicatorFrame.Bots[bot.Class] or {}

	
	if IndicatorFrame.Bots[bot.Class][bot.Id] then
		print("Повторная регистрация бота для Class = ", bot.Class," и спека = ",bot.Id)
		return
	end
	
	--print("Регистрируем бота для Class = ", bot.Class," и спека = ",bot.Id)
	IndicatorFrame.Bots[bot.Class][bot.Id] = bot
end


function TBOnPlayerLogin(self)
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
	IndicatorFrame.Spec = nil
    TBUnregisterAllSpells() 
	TBClearPanel()
	
    local name,class = UnitClass("player")
    print("Загружаются боты для класса",name)

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
	IndicatorFrame.Spec = IndicatorFrame.Bots[class][currentTalents]
	
	for key, id in pairs(IndicatorFrame.Spec.Spells) do
		TBRegisterSpell(GetSpellInfo(id),id)
	end
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
			if v > 5 then
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
					local link = GetContainerItemLink(bag, slot)
					local key = 0
					if link then
						key = tonumber(link:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:%d+:(%d+)"))
					end
					
					if quality == 0 then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					if quality == 2 and equipSlot and equipSlot~="" and equipSlot~="INVTYPE_BAG" then
						PickupContainerItem(bag, slot)
						PickupMerchantItem()
					end
					
					if quality == 3 and ilvl < 500 and key ~= 512 and equipSlot and equipSlot~="" and equipSlot~="INVTYPE_BAG" then
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
					if (name == "Большой ящик для утиля" or name == "Большой ящик с утилем" or name == "Сумка с утилем" or name == "Ящик для утиля" or name == "Ящик с утилем") and TBBagActions.Salvage == nil  then
						macrotext = macrotext.. name
						TBSetMacro(macrotext)
						TBBagActions.Salvage = 1
					end
				end
			end
		end
		return "macro"
	end
	
	if TBBagActions.Click then
		TBBagActions.Click = nil
		local macrotext = "/use "
		for bag = 0,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				if id then
					local name = GetItemInfo(id)
					if name == "Расколотый кристалл времени" and TBBagActions.Click == nil  then
						macrotext = macrotext..name
						TBSetMacro(macrotext)
						TBBagActions.Click = 1
					end
				end
			end
		end
		return "macro"
	end
	
	if TBBagActions.Mail then
		local idx = 1
		for bag = 0,4 do
			for slot = 1,GetContainerNumSlots(bag) do
				local id = GetContainerItemID(bag, slot)
				if id then
					local name = GetItemInfo(id)				
					if name =="Сырая шкура зверя " then
						PickupContainerItem(bag, slot)
						ClickSendMailItemButton(idx, false)
						idx = idx + 1
					end
				end
			end
		end
		--SendMail("Логрис","routing")
		
		print("TBBagActions.Mail")
		TBBagActions.Mail = nil
	end
end

function TBOnUpdate()
	if IndicatorFrame.Spec then
		local cmd = IndicatorFrame.Spec:OnUpdate(TBGroups(), TBList(), PanelFrame.Groups) or TBMacroCommands()
		if cmd then
			IndicatorFrame.LastCommand = cmd
		end
		TBCommand(cmd)
	else
		local cmd = TBMacroCommands()
		if cmd then
			IndicatorFrame.LastCommand = cmd
		end
		TBCommand(cmd)
		
	end
end

function TBLoSData(self, event,...)
	--Заполняем информацию для LoS
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

function TBEnterCombat() 
	IndicatorFrame.InCombat = 1	
end

function TBLeaveCombat() 
	IndicatorFrame.InCombat = nil	
end











