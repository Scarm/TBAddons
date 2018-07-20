BaseGroupHelper.LastCast = {}
BaseGroupHelper.LastCast.Targets = {}

local LastCastExeptions =
	{
	}

function BaseGroup:LastCast(key, isLast, total)
	BaseGroupHelper.LastCast.LastSpellTime = BaseGroupHelper.LastCast.LastSpellTime or 0

	if GetTime() > BaseGroupHelper.LastCast.LastSpellTime then
		BaseGroupHelper.LastCast.LastSpell = nil
	end

	if isLast == nil then
		return nil
	end

	local isLastCast = (BaseGroupHelper.LastCast.LastSpell or -1) == IndicatorFrame.Spec.Spells[key]
	if isLast == isLastCast then
		return self
	end


	local result = self:CreateDerived()
	if isLast or total then
		return result
	end

	for key,value in pairs(self) do
		if UnitName(key) == BaseGroupHelper.LastCast.LastTarget then
			--print("Исключаем: ", key, "(",UnitName(key),")" )
		else
			result[key] = value
		end
	end

	return result
end


function TBLastCastUpdate(self, event,...)
	--print(event,">>>>",...)
	local caster, spellUid, spellId  = select(1,...)
	-- Если колдовали мы
	if caster=="player" then

		if LastCastExeptions[spellId] then
			return
		end
		-- И спелл, за которым надо следить
		BaseGroupHelper.LastCast.LastSpell = spellId
		BaseGroupHelper.LastCast.LastTarget = BaseGroupHelper.LastCast.Targets[spellUid]

		--print(UnitCastingInfo("player"))
		--print(UnitChannelInfo("player"))
		local et = select(5,UnitCastingInfo("player")) or select(5, UnitChannelInfo("player"))
		if et then
			BaseGroupHelper.LastCast.LastSpellTime = (et/1000) + 1 -- время окончания плюс секунда
		else
			BaseGroupHelper.LastCast.LastSpellTime = GetTime() + 1
		end
	end
end

function TBLastCastUpdateFailed(self, event,...)
	--print(event,">>>>",...)
	local caster, spellUid, spellId  = select(1,...)
	if unitId=="player" then
		BaseGroupHelper.LastCast.LastSpell = nil
	end
end

-- Цель этого метода - сопоставление уникального id спелла и цели этого спелла
function TBLastCastData(self, event,...)
	--print(event,">>>>",...)
	local caster, targetName, spellUid  = select(1,...)
	--Заполняем инфрмацию для LastCast
	if (caster == "player") then
		BaseGroupHelper.LastCast.Targets[ spellUid ] = targetName
	end
end


TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_CHANNEL_START", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_CHANNEL_UPDATE", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_CHANNEL_STOP", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_DELAYED", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_INTERRUPTED", "TBLastCastUpdateFailed")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_START", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_SUCCEEDED", "TBLastCastUpdate")
TBSubscribeEvent(BaseGroupHelper,"UNIT_SPELLCAST_SENT", "TBLastCastData")
