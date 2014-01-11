function TBCreateIndicators(self)
    IndicatorFrame.Frames = {}
	IndicatorFrame.Rows = 48
	for row= 0,1,1 do
        for i=0,IndicatorFrame.Rows - 1,1 do
			local pos = row * IndicatorFrame.Rows + i
            ind = CreateFrame("Button","TBInd_"..pos,IndicatorFrame,"AutomatonFrameTemplate")
            ind:SetPoint("TOPLEFT",i * 5 ,-5 * row )
            IndicatorFrame.Frames[pos] = ind 
        end
    end

	TBClearControls()
	TBSetBindings()
	TBUnregisterAllSpells()
	TBUnregisterAllTargets()
end

function TBClearControls()
    for i = 0, IndicatorFrame.Rows * 2 - 1, 1 do
        IndicatorFrame.Frames[i].Tex:SetTexture(0.0, 0.0, 0.0, 1.0);
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
		SetOverrideBindingClick(IndicatorFrame, true, "ALT-CTRL-SHIFT-"..bind, "TBInd_"..(i+82))			
    end
end

function TBUnregisterAllSpells()
    -- сбрасываем счетчик спеллов
    IndicatorFrame.SpellCount = 0
    -- очищаем карту индикаторов
    IndicatorFrame.Spells = {}
	
	for i=0,35,1 do
		IndicatorFrame.Frames[i]:SetAttribute("type","spell")
		IndicatorFrame.Frames[i]:SetAttribute("spell",nil)
		IndicatorFrame.Frames[i]:SetAttribute("unit","target")
	end
end

function TBUnregisterAllTargets()
    -- сбрасываем счетчик Целей
    IndicatorFrame.TargetCount = 0
    -- очищаем карту индикаторов
    IndicatorFrame.Targets = {}
	
	for i=48,87,1 do
		IndicatorFrame.Frames[i]:SetAttribute("type","target")
		IndicatorFrame.Frames[i]:SetAttribute("unit",nil)
	end
end

function TBRegisterSpell(spell)
	-- может быть забиндено только 36 спеллов
    if IndicatorFrame.SpellCount==36 then
		print("Ошибка регистрации спеллов!!!")
        return
    end

    -- биндим спелл
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("type","spell")
	IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("spell",spell.BaseName)
    --IndicatorFrame.Frames[IndicatorFrame.SpellCount]:SetAttribute("unit","target")

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    IndicatorFrame.Spells[spell.BaseId] = IndicatorFrame.SpellCount 
    IndicatorFrame.SpellCount = IndicatorFrame.SpellCount + 1
end


function TBRegisterTarget(name)

	-- может быть забиндено только 40 целей
    if IndicatorFrame.TargetCount==40 then
		print("Ошибка регистрации целей!!!")
        return
    end
    print("зарегистрирован: ",name)

    -- биндим цель
	IndicatorFrame.Frames[IndicatorFrame.TargetCount+self.Rows]:SetAttribute("type","target")
    IndicatorFrame.Frames[IndicatorFrame.TargetCount+self.Rows]:SetAttribute("unit",name)

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    IndicatorFrame.Targets[name] = IndicatorFrame.TargetCount+self.Rows
    IndicatorFrame.TargetCount = IndicatorFrame.TargetCount + 1
end

function TBCastSpell(spell)
    TBClearControls()
	IndicatorFrame.Frames[ IndicatorFrame.Spells[spell.BaseId] ].Tex:SetTexture(1.0, 1.0, 1.0, 1.0);
end

function TBTarget(name)  
	IndicatorFrame.Frames[ IndicatorFrame.Targets[name] ].Tex:SetTexture(1.0, 1.0, 1.0, 1.0);
end