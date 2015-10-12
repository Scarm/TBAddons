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
					}
				}
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
	local spells = TBSpecInfo.spec.Spells
	
	-- у хороших спеллов lineID не нулевой, у остальных 0
	if lineID ~= 0 then		
		if spells[spell] == nil then
			spells[spell] = spellID
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
				-- если бафф с таким именем уже есть, тогда записываем его с постфиксом
				if buffs[name] ~= id then
					-- добавляем постфиксы, пока не обнаружим свободное значение
					while buffs[name] do
						name = name.."_"
					end
					buffs[name] = id
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
				-- если бафф с таким именем уже есть, тогда записываем его с постфиксом
				if buffs[name] ~= id then
					-- добавляем постфиксы, пока не обнаружим свободное значение
					while buffs[name] do
						name = name.."_"
					end
					buffs[name] = id
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











