function TBSpecInfoSet()
	if not IsLoggedIn() then
		return
	end
	

	TBSpecInfoData = TBSpecInfoData or {}
	
	local _,class = UnitClass("player")
	TBSpecInfoData[class] = TBSpecInfoData[class] or {}
	local classInfo = TBSpecInfoData[class]
	
	for specId = 1, GetNumSpecializations(), 1 do
		local id, name, description, icon, background, role = GetSpecializationInfo(specId)
		
		if classInfo[name] == nil then
			print("Создаем пустую болванку для "..class.."("..name..")" )
			classInfo[name] = {}
			local spec = classInfo[name]
			
			spec.Class = class
			spec.Id = specId
			spec.Name = name
			spec.Spells = {}	
			spec.Buffs = {}	
			
			--Interface\\ICONS\\INV_Banner_01.blp
			--Interface\\ICONS\\INV_Misc_Bandage_08.blp
			--Interface\\ICONS\\INV_Misc_GroupLooking.blp
			--Interface\\ICONS\\INV_Misc_GroupNeedMore.blp
			--INTERFACE\\ICONS\\INV_Misc_Bone_HumanSkull_02.blp
			--Interface\\ICONS\\INV_Misc_Bone_Skull_02.blp
			--Interface\\ICONS\\INV_Misc_EngGizmos_27.blp
			if role == "DAMAGER" then
				-- дефолтные заглушки кнопочек
				spec.Buttons = 
					{
						[1] = {
							Icon = "Interface\\Icons\\ABILITY_SEAL",
							ToolTip = "Off",
							GroupId = "Run",
						},
						[2] = {
							Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
							ToolTip = "On",
							GroupId = "AoE"
						},
						[3] = {
							["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
							["ToolTip"] = "On",
							["GroupId"] = "Burst",
						},
						[4] = {
							["Icon"] = "Interface\\ICONS\\INV_Misc_GroupNeedMore.blp",
							["ToolTip"] = "On",
							["GroupId"] = "Party",
							["default"] = 1
						},	
					}
			end
			if role == "TANK" then
				-- дефолтные заглушки кнопочек
				spec.Buttons = 
					{
						[1] = {
							Icon = "Interface\\Icons\\ABILITY_SEAL",
							ToolTip = "Off",
							GroupId = "Run",
						},
						[2] = {
							Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
							ToolTip = "On",
							GroupId = "AoE"
						},
						[3] = {
							["Icon"] = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
							["ToolTip"] = "On",
							["GroupId"] = "Burst",
						},
						[4] = {
							["Icon"] = "Interface\\ICONS\\INV_Misc_GroupNeedMore.blp",
							["ToolTip"] = "On",
							["GroupId"] = "Party",
						},	
					}
			end
		end
	end

	
	local id, name = GetSpecializationInfo(GetSpecialization())
	
	TBSpecInfo.spec = TBSpecInfoData[class][name]
	TBSpecInfoUpdateList()
end

function TBSpecInfoClear()
	local _,class = UnitClass("player")
	local id, name = GetSpecializationInfo(GetSpecialization())
	TBSpecInfoData[class][name] = nil
	
	TBSpecInfoSet()
end

function TBSpecInfoAddSpell(self,event,unitID,spell,rank,lineID,spellID)
	if not (IsLoggedIn() and TBSpecInfo:IsShown()) then
		return
	end
	local buffs = TBSpecInfo.spec.Buffs
	local spells = TBSpecInfo.spec.Spells
	
	-- у хороших спеллов lineID не нулевой, у остальных 0
	if lineID ~= 0 then		
		if spells[spell] == nil then
			spells[spell] = spellID
			
			buffs[spell] = nil 
		end
	end
	TBSpecInfoUpdateList()
end

function TBSpecInfoAddAura(self, event, target)
	if not (IsLoggedIn() and TBSpecInfo:IsShown()) then
		return
	end
	local buffs = TBSpecInfo.spec.Buffs
	local spells = TBSpecInfo.spec.Spells
	
	for i=1,40,1 do
		local name = UnitAura(target,i,"PLAYER")
		local id = select(11, UnitAura(target,i,"PLAYER"))
		
		if name then
			-- если такого баффа нет в списке спеллов, тогда его можно занести в список баффов
			if spells[name] ~= id then
				-- Если такого баффа не было - записываем его
				if buffs[name] == nil then
					buffs[name] = id
				end
				-- добавляем постфиксы, пока не обнаружим свободное значение
				while buffs[name] and buffs[name]~= id do
					name = name.."_"
				end
				buffs[name] = id
				
				-- возможна ситуация, когда сначала повесился бафф, затем его удалили спеллом (бафф был повешен до начала записи логов)
				-- в этой ситуации где то дальше может быть дубль уже записанного спелла
				-- надо его найти и занулить
				while buffs[name] do
					name = name.."_"
					if buffs[name] == id then
						buffs[name] = nil
					end
				end
				
			end
		end
	end
	for i=1,40,1 do
		local name = UnitAura(target,i,"HARMFUL|PLAYER")
		local id = select(11, UnitAura(target,i,"HARMFUL|PLAYER"))
		
		if name then
			-- если такого баффа нет в списке спеллов, тогда его можно занести в список баффов
			if spells[name] ~= id then
				-- Если такого баффа не было - записываем его
				if buffs[name] == nil then
					buffs[name] = id
				end
				-- добавляем постфиксы, пока не обнаружим свободное значение
				while buffs[name] and buffs[name]~= id do
					name = name.."_"
				end
				buffs[name] = id
				
				-- возможна ситуация, когда сначала повесился бафф, затем его удалили спеллом (бафф был повешен до начала записи логов)
				-- в этой ситуации где то дальше может быть дубль уже записанного спелла
				-- надо его найти и занулить
				while buffs[name] do
					name = name.."_"
					if buffs[name] == id then
						buffs[name] = nil
					end
				end
			end
		end
	end	
	TBSpecInfoUpdateList()
end

function TBSpecInfoUpdateList()

	local _,height = TBSpecInfoList:GetFont()
	local text = ""
	local strings = 0
	for name,spellId in pairs(TBSpecInfo.spec.Spells) do
		if text~="" then
			text = text.."\n"
		end
		text = text..(GetSpellLink(spellId) or "nil").."("..spellId..")"
		strings = strings + 1
	end
	
	text = text.."\n"
	
	for name,spellId in pairs(TBSpecInfo.spec.Buffs) do
		if text~="" then
			text = text.."\n"
		end
		text = text..GetSpellLink(spellId).."("..spellId..")"
		strings = strings + 1
	end	
		
	TBSpecInfoList:SetHeight(strings * height)
	TBSpecInfoList:SetText(text)
end











