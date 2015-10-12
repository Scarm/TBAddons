function TBCommitCombat()
	local party = TBGroups().party
	if party:AffectingCombat():Any() then
		return
	end

	TBHelperCollection = TBHelperCollection or {}
		
	-- если не найден босс - записываем все в один комбат зоны
	 if TBTmp.Debuffs and TBTmp.Targets then
		 TBTmp.BossName = TBTmp.BossName or GetRealZoneText()
	 end
	--если нашлось хоть одно имя босса - значит это стоит записать
	if TBTmp.BossName then
		print("Начали запись результатов боя")
		
		-- создаем нужные таблицы
		TBHelperCollection[GetRealZoneText()] = TBHelperCollection[GetRealZoneText()] or {}
		local zone = TBHelperCollection[GetRealZoneText()]
		
		zone[TBTmp.BossName]  = zone[TBTmp.BossName] or {}
		local boss = zone[TBTmp.BossName]
		
		boss["debuffs"] = boss["debuffs"] or {}
		boss["targets"] = boss["targets"] or {}		
		local debuffs = boss["debuffs"]
		local targets = boss["targets"]
		
		-- заполняем из временного хранилища значения, которых нет в главном хранилище
		for k,v in pairs(TBTmp.Debuffs) do
			debuffs[k] = debuffs[k] or v
		end
		for k,v in pairs(TBTmp.Targets) do
			targets[k] = targets[k] or v
		end
		
		-- повторно сюда не заходим
		TBTmp.BossName = nil
		TBTmp.Debuffs = nil
		TBTmp.Targets = nil
	end		
end

function TBScanDebuffs(self, event, target)
	local party = TBGroups().party	
	-- Начинаем запись только если кто то в группе вступил в бой
	if party:AffectingCombat():Any() then
		
		TBTmp.Debuffs = TBTmp.Debuffs or {}
		TBTmp.Targets = TBTmp.Targets or {}
		if TBTmp.BossName == nil and UnitName("boss1") then
			TBTmp.BossName = UnitName("boss1")
		end
		if event=="UNIT_AURA" and UnitCanAssist("player", target) then
			for i=1,40,1 do
				local id = select(11, UnitAura(target,i,"HARMFUL"))
				if id and TBTmp.Debuffs[id] == nil then
					TBTmp.Debuffs[id] = {}
					local v = TBTmp.Debuffs[id]
					v.name, 
					v.rank, 
					v.icon, 
					v.count,  
					v.dispelType,  
					v.duration,  
					v.expires,  
					v.caster,  
					v.isStealable,  
					v.shouldConsolidate,  
					v.spellID,  
					v.canApplyAura,  
					v.isBossDebuff,  
					v.value1,  
					v.value2,  
					v.value3 = UnitAura(target,i,"HARMFUL")

					print("debuff logged: ", id)
				end
			end
		end
		
		if event=="UNIT_TARGET" and  UnitCanAttack("player", target.."target") then
			local name = UnitName(target.."target")
			if name and TBTmp.Targets[name] == nil then
				TBTmp.Targets[name] = 0
				print("target logged: ", name)
			end
		end

	end
end

--Настраиваем меню выбора боя
function TBInitDropDowns()
	local function OnZoneClick(self)
	   UIDropDownMenu_SetSelectedName(TBZoneSelection, self:GetText())
	   --print(TBZoneSelection.selectedName)
	   UIDropDownMenu_SetSelectedName(TBBossSelection, nil)
	   UIDropDownMenu_Initialize(TBBossSelection, initBossSelection)
	   TBCollectionFrame.SelectedBoss = nil
	   TBShowDebuffList()
	end
	
	local function initZoneSelection(self, level)
		if TBHelperCollection then
			for k,v in pairs(TBHelperCollection) do
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = OnZoneClick
				UIDropDownMenu_AddButton(info, level)
			end	
		end
	end
	
	UIDropDownMenu_Initialize(TBZoneSelection, initZoneSelection)
	UIDropDownMenu_SetWidth(TBZoneSelection, 150)
	UIDropDownMenu_SetButtonWidth(TBZoneSelection, 50)
	UIDropDownMenu_JustifyText(TBZoneSelection, "LEFT")
	TBZoneSelection:Show()
	
	local function OnBossClick(self)
	   UIDropDownMenu_SetSelectedName(TBBossSelection, self:GetText())
	   --print(TBBossSelection.selectedName)
	   TBCollectionFrame.SelectedBoss = TBHelperCollection[TBZoneSelection.selectedName][TBBossSelection.selectedName]
	   TBShowDebuffList()
	end
	
	local function initBossSelection(self, level)
		if TBHelperCollection and TBHelperCollection[TBZoneSelection.selectedName] then 
			for k,v in pairs(TBHelperCollection[TBZoneSelection.selectedName]) do
				info = UIDropDownMenu_CreateInfo()
				info.text = k
				info.value = v
				info.func = OnBossClick
				UIDropDownMenu_AddButton(info, level)
			end	
		end
	end
	
	UIDropDownMenu_Initialize(TBBossSelection, initBossSelection)
	UIDropDownMenu_SetWidth(TBBossSelection, 150)
	UIDropDownMenu_SetButtonWidth(TBBossSelection, 50)
	UIDropDownMenu_JustifyText(TBBossSelection, "LEFT")
	TBBossSelection:Show()

	TBCollectionFrame.SelectedBoss = nil
	TBShowDebuffList()
end

function TBClearDebuff(frame)
	frame:Hide()
	if frame.next then
		TBClearDebuff(frame.next)
	end
end

function TBGetDebuffButton()
	if TBCollectionFrame.first then
		--если попали сюда - значит хотя бы одна кнопка создана
		
		if TBCollectionFrame.last == nil then
			--список уже был создан, но очищен. Нужно получить самый первый элемент 
			TBCollectionFrame.last = TBCollectionFrame.first

		else
			if TBCollectionFrame.last.next == nil then
				local idx = TBCollectionFrame.last.idx + 1
				local button = CreateFrame("Button","TBCollectionDebuffButton"..idx,TBCollectionFrame,"TBCollectionDebuffTemplate")
				button:SetPoint("TOP", TBCollectionFrame.last,"BOTTOM", 0, -4)
				button.idx = idx
				TBCollectionFrame.last.next = button
			end
			TBCollectionFrame.last = TBCollectionFrame.last.next
		end
	else
		local idx = 1
		local button = CreateFrame("Button","TBCollectionDebuffButton"..idx,TBCollectionFrame,"TBCollectionDebuffTemplate")
		--button:SetPoint("TOP", TBCollectionFrame,"BOTTOM", -55, -60)
		button:SetPoint("TOP", TBCollectionFrame,"BOTTOM", -55, -120)

		TBCollectionFrame.first = button
		TBCollectionFrame.last = button
		TBCollectionFrame.last.idx = idx
	end
	return TBCollectionFrame.last
end

function TBShowDebuffList()
	TBAttributes = TBAttributes or {}
	--TBAttributes["incoming damage"] = TBAttributes["incoming damage"] or {}
	--TBAttributes["absorb heal"] = TBAttributes["absorb heal"] or {}
	--TBAttributes["not decurse"] = TBAttributes["not decurse"] or {}
	

	local function SetVisibility(actionButton)
		if actionButton.filter == TBCollectionFrame.filter then
			actionButton:Show()
		else
			actionButton:Hide()
		end
	end

	--Очищаем список
	if TBCollectionFrame.first then
		TBClearDebuff(TBCollectionFrame.first)
		TBCollectionFrame.last = nil
	end
	
	if TBCollectionFrame.SelectedBoss then
		TBHelperIgnores = TBHelperIgnores or {}
		TBHelperIgnores.debuffs = TBHelperIgnores.debuffs or {}
	
		local debuffs = TBCollectionFrame.SelectedBoss.debuffs
		
		--помечаем все спеллы из списка полного игнора
		for id, data in pairs(debuffs) do
			if TBHelperIgnores.debuffs[id] then
				data.filter = "full ignore"
			end
		end
		
		for id, data in pairs(debuffs) do
			if data.filter == TBCollectionFrame.filter then
				local button = TBGetDebuffButton()
				button.spellID = id
				button.data = data
				button.icon:SetTexture(button.data.icon)
				button:Show()
				
				SetVisibility(button.addKey)
				SetVisibility(button.ignoreKey)	
				
				SetVisibility(button.returnKey1)
				SetVisibility(button.dotKey)
				SetVisibility(button.absorbKey)
				SetVisibility(button.decurseKey)
				SetVisibility(button.fullHealKey)
				
				
				SetVisibility(button.returnKey2)				
				SetVisibility(button.fullIgnoreKey)				
			end
		end
	end		
end




















