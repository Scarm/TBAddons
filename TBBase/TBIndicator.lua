﻿function TBCreateIndicators(self)
	print("TBCreateIndicators")
    IndicatorFrame.Frames = {}
	IndicatorFrame.Rows = 48
	for row= 0,1,1 do
        for i=0,IndicatorFrame.Rows - 1,1 do
			local pos = row * IndicatorFrame.Rows + i
            ind = CreateFrame("Button","TBInd_"..pos,IndicatorFrame,"AutomatonFrameTemplate")
            ind:SetPoint("TOPLEFT",i * 5 ,-5 * row )

			-- это изврашение - результат пропуска биндинга кнопок без модификаторов
			if pos < 36 then
				IndicatorFrame.Frames[pos] = ind
			else
				if pos < 48 then
					IndicatorFrame.Frames[pos + 48] = ind
				else
					IndicatorFrame.Frames[pos - 12] = ind
				end
			end
        end
    end

	TBClearControls()
	TBSetBindings()
	TBUnregisterAllSpells()
	TBSetStaticCommands()
end

function TBClearControls()

    for i = 0, IndicatorFrame.Rows * 2 - 1, 1 do
        IndicatorFrame.Frames[i].Tex:SetVertexColor(0, 0, 0)
    end
end

function TBSetBindings()
	for i=0,11,1 do
        if i<9 then bind = i+1 end
        if i==9 then  bind = 0 end
        if i==10 then bind = "-" end
        if i==11 then bind = "=" end
        -- первая строка
		SetOverrideBindingClick(IndicatorFrame, true, "CTRL-" ..bind, "TBInd_"..i)
		SetOverrideBindingClick(IndicatorFrame, true, "ALT-"  ..bind, "TBInd_"..(i+12))
		SetOverrideBindingClick(IndicatorFrame, true, "SHIFT-"..bind, "TBInd_"..(i+24))
		-- не переписываем биндинги главной панели
		--SetOverrideBindingClick(self.Frame, true,           bind, "TB3_Ind"..(i+36))
        -- вторая строка
		SetOverrideBindingClick(IndicatorFrame, true, "ALT-CTRL-"      ..bind, "TBInd_"..(i+48))
		SetOverrideBindingClick(IndicatorFrame, true, "CTRL-SHIFT-"    ..bind, "TBInd_"..(i+60))
		SetOverrideBindingClick(IndicatorFrame, true, "ALT-SHIFT-"     ..bind, "TBInd_"..(i+72))
		SetOverrideBindingClick(IndicatorFrame, true, "ALT-CTRL-SHIFT-"..bind, "TBInd_"..(i+84))
    end
end

function TBUnregisterAllSpells()
    -- сбрасываем счетчик спеллов
    IndicatorFrame.SpellCount = 0
    -- очищаем карту индикаторов
    IndicatorFrame.Spells = {}

	for i=0,23,1 do
		IndicatorFrame.Frames[i]:SetAttribute("type","spell")
		IndicatorFrame.Frames[i]:SetAttribute("spell",nil)
		IndicatorFrame.Frames[i]:SetAttribute("unit","target")
	end
end

-- тут биндятся команды, независимые от спека/списка спеллов
function TBSetStaticCommands()
    -- сбрасываем счетчик Целей
    IndicatorFrame.TargetCount = 24
    -- очищаем карту индикаторов
    IndicatorFrame.Targets = {}

	--[[
	for i=24,83,1 do
		IndicatorFrame.Frames[i]:SetAttribute("type","target")
		IndicatorFrame.Frames[i]:SetAttribute("unit",nil)
	end
	--]]

	commands = {}
	commands["player"] = 1
	commands["focus"] = 1
	commands["targetpet"] = 1
	commands["mouseover"] = 1

	for i=1,4,1 do
		commands["party"..i] = 1
	end
	for i=1,40,1 do
		commands["raid"..i] = 1
	end
	for i=1,4,1 do
		commands["boss"..i] = 1
	end


	for name,value in pairs(commands) do
		-- исключаем комбинацию CTRL-SHIFT-0 - она перехватывается виндой
		if IndicatorFrame.TargetCount == 57 then
			IndicatorFrame.TargetCount = IndicatorFrame.TargetCount + 1
		end

		-- биндим цель
		IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("type","target")
		IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("unit",name)

		-- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
		IndicatorFrame.Targets[name] = IndicatorFrame.TargetCount
		IndicatorFrame.TargetCount = IndicatorFrame.TargetCount + 1
	end

	-- Команда Assist работает как с дружественной, так и с враждебной целью. Это может вызвать тремор,
	-- поэтому мы делаем спец заглушку: мы может переключить ассист тольок с дружественной цели.
	-- Возможно, будет иметь смысл сделать специальные команды ассиста дружественной и враждебной цели.
	IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("helpbutton","heal")
	IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("type-heal","assist")
	--IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("type","assist")
	IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("unit","target")
	IndicatorFrame.Targets["assist"] = IndicatorFrame.TargetCount

	print(IndicatorFrame.TargetCount)
	IndicatorFrame.TargetCount = IndicatorFrame.TargetCount + 1


	IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("type","focus")
	IndicatorFrame.Frames[IndicatorFrame.TargetCount]:SetAttribute("unit","target")
	IndicatorFrame.Targets["setfocus"] = IndicatorFrame.TargetCount
	IndicatorFrame.TargetCount = IndicatorFrame.TargetCount + 1

	IndicatorFrame.Targets["macro"] = 83
end

function TBSetMacro(text)
	IndicatorFrame.Frames[83]:SetAttribute("type","macro")
	IndicatorFrame.Frames[83]:SetAttribute("macrotext",text)
end


function TBRegisterSpell(spell,id)
	--if spell then print(spell) end
	-- может быть забиндено только 24 спеллов
    if IndicatorFrame.SpellCount==24 then
		print("Ошибка регистрации спеллов!!!")
        return
    end

    -- биндим спелл
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("type","spell")
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("spell",spell)

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    IndicatorFrame.Spells[spell] = IndicatorFrame.SpellCount
    IndicatorFrame.SpellCount = IndicatorFrame.SpellCount + 1
end

function TBRegisterMacro(key, text)
	--if spell then print(spell) end
	-- может быть забиндено только 24 спеллов
    if IndicatorFrame.SpellCount==24 then
		print("Ошибка регистрации спеллов!!!")
        return
    end

    -- биндим спелл
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("type","macro")
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("macrotext",text)

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    IndicatorFrame.Spells[key] = IndicatorFrame.SpellCount
    IndicatorFrame.SpellCount = IndicatorFrame.SpellCount + 1
end

function TBCommand(name)
	--if name then print(name) end
	IndicatorFrame.DebugIndicatorName = name
    TBClearControls()
	local id = IndicatorFrame.Spells[name] or IndicatorFrame.Targets[name]

	if id then
		IndicatorFrame.Frames[ id ].Tex:SetVertexColor(1, 1, 1)
	end
end
