local TBCorrectSpells = {}

function TBSpecInfoSet()
	if not IsLoggedIn() then
		return
	end

	TBSpecInfoData = TBSpecInfoData or {}

	local _,class = UnitClass("player")
	TBSpecInfoData[class] = TBSpecInfoData[class] or {}
	local classInfo = TBSpecInfoData[class]

	for specId = 1, GetNumSpecializations(), 1 do
		local id, name, description, icon, role = GetSpecializationInfo(specId)
		--print(GetSpecializationInfo(specId))
		if classInfo[name] == nil then
			print("Создаем пустую болванку для "..class.."("..name..")" )
			classInfo[name] = {}
			local spec = classInfo[name]

			spec.Class = class
			spec.Id = specId
			spec.Name = name
			spec.Spells = {}
			spec.Buffs = {}
			spec.Talents = {}

			for col = 1,3,1 do
				for row = 1,7,1 do
					local id,nm = GetTalentInfoBySpecialization(specId, row, col)
					spec.Talents[nm] = id
				end
			end

			--Interface\\ICONS\\INV_Banner_01.blp
			--Interface\\ICONS\\INV_Misc_Bandage_08.blp
			--Interface\\ICONS\\INV_Misc_GroupLooking.blp
			--Interface\\ICONS\\INV_Misc_GroupNeedMore.blp
			--INTERFACE\\ICONS\\INV_Misc_Bone_HumanSkull_02.blp
			--Interface\\ICONS\\INV_Misc_Bone_Skull_02.blp
			--Interface\\ICONS\\INV_Misc_EngGizmos_27.blp
			--print(role)
			if role == "DAMAGER" then
				-- дефолтные заглушки кнопочек
				spec.Buttons =
					{
						[1] = {
							Type = "trigger",
							Icon = "Interface\\Icons\\ABILITY_SEAL",
							Name = "Stop",
						},
						[2] = {
							Type = "trigger",
							Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
							Name = "AoE",
						},
						[3] = {
							Type = "trigger",
							Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
							Name = "Burst",
						},
						[4] = {
							Type = "selector",
							Name = "Interrupt",
							Values =
							{
								{
									Value = "first",
									Icon = 876914,
								},
								{
									Value = "mid",
									Icon = 876916,
								},
								{
									Value = "last",
									Icon = 876915,
									default = 1,
								},
							},
						},
						[5] = {
							Type = "trigger",
							Icon = 135915,
							Name = "Heal",
						},
					}
			end
			if role == "TANK" then
				-- дефолтные заглушки кнопочек
				spec.Buttons =
					{
						[1] = {
							Type = "trigger",
							Icon = "Interface\\Icons\\ABILITY_SEAL",
							Name = "Stop",
						},
						[2] = {
							Type = "trigger",
							Icon = "Interface\\Icons\\Ability_Warrior_Bladestorm",
							Name = "AoE",
						},
						[3] = {
							Type = "trigger",
							Icon = 1377132,
							Name = "Def",
						},
						[4] = {
							Type = "selector",
							Name = "Interrupt",
							Values =
							{
								{
									Value = "first",
									Icon = 876914,
								},
								{
									Value = "mid",
									Icon = 876916,
								},
								{
									Value = "last",
									Icon = 876915,
									default = 1,
								},
							},
						},
					}
			end
			if role == "HEALER" then
				-- дефолтные заглушки кнопочек
				spec.Buttons =
					{
						[1] = {
							Type = "trigger",
							Icon = "Interface\\Icons\\ABILITY_SEAL",
							Name = "Stop",
						},
						[2] = {
							Type = "trigger",
							Icon = "Interface\\ICONS\\Inv_Misc_SummerFest_BrazierRed.blp",
							Name = "Burst",
						},
						[3] = {
							Type = "trigger",
							Icon = "Interface\\ICONS\\Spell_Holy_SummonLightwell.blp",
							Name = "Preheal",
						},
					}
			end
		end
	end


	local id, name = GetSpecializationInfo(GetSpecialization())

	TBSpecInfo.spec = TBSpecInfoData[class][name]
	TBSpecInfo.spec.Buffs = TBSpecInfo.spec.Buffs or {}
	TBSpecInfo.spec.Spells = TBSpecInfo.spec.Spells or {}
	--print("TBSpecInfoSet")
	TBSpecInfoUpdateList()
	TBCreateCorrectSpellList()
end

function TBCreateCorrectSpellList()
	local _,_,offset = GetSpellTabInfo(3)

	TBCorrectSpells = {}
    for index = 1, offset, 1 do
		local id = select(7,GetSpellInfo(index, "spell"))
		local name = GetSpellInfo(index, "spell")
		if id then -- сраный косяк близов
			TBCorrectSpells[id] = name
		end
	end

end

function TBSpecInfoClear()
	local _,class = UnitClass("player")
	local id, name = GetSpecializationInfo(GetSpecialization())
	TBSpecInfoData[class][name] = nil

	TBSpecInfoSet()
end

function TBSpecInfoAddSpell(self,event,caster, uid, spellID)
	if not (IsLoggedIn() and TBSpecInfo:IsShown()) then
		return
	end
	--print("Add spell", caster, uid, spellID)
	local buffs = TBSpecInfo.spec.Buffs
	local spells = TBSpecInfo.spec.Spells

	--print(event,unitID,spell,rank,lineID,spellID)
	local spell = GetSpellInfo(spellID)
	if TBCorrectSpells[spellID] then
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
	--print("Add aura")

	local buffs = TBSpecInfo.spec.Buffs
	local spells = TBSpecInfo.spec.Spells

	for i=1,40,1 do
		local name = UnitAura(target,i,"PLAYER")
		local id = select(10, UnitAura(target,i,"PLAYER"))

		if name then
			--print(UnitAura(target,i,"PLAYER"))
			--print(name, id)
			--print(name,id,type(id) )
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
		local id = select(10, UnitAura(target,i,"HARMFUL|PLAYER"))

		if name then
			-- если такого баффа нет в списке спеллов, тогда его можно занести в список баффов
			--print(name, id)
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

	if TBSpecInfo.spec then
		for name,spellId in pairs(TBSpecInfo.spec.Spells) do
			if text~="" then
				text = text.."\n"
			end
			text = text..(GetSpellLink(spellId) or "nil").."("..spellId..")"
			strings = strings + 1
		end


		text = text.."\n"
		for name,spellId in pairs(TBSpecInfo.spec.Buffs) do
			--print("buffs", name, spellId)
			if text~="" then
				text = text.."\n"
			end
			text = text..GetSpellLink(spellId).."("..spellId..")"
			strings = strings + 1
		end

	end


	TBSpecInfoList:SetHeight(strings * height)
	TBSpecInfoList:SetText(text)
end
