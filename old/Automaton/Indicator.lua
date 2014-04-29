AutomatonIndicator = {}
Automaton.Indicator = AutomatonIndicator
AutomatonIndicator.Rows = 48

function AutomatonIndicator:OnLoad(frame)
	self.Frame = frame
    self:CreateIndicators()
	self:ClearControls()
	self:SetBindings()
	self:UnregisterAllSpells()
	self:UnregisterAllTargets()
end

function AutomatonIndicator:CreateIndicators()
	self.Frames = {}
    for row= 0,1,1 do
        for i=0,self.Rows-1,1 do
			local pos = row*self.Rows+i
            ind = CreateFrame("Button","Automaton_"..pos,self.Frame,"AutomatonFrameTemplate")
            ind:SetPoint("TOPLEFT",i*5 ,-5*row )
            self.Frames[pos] = ind 
        end
    end
end

function AutomatonIndicator:ClearControls()
    for i = 0, self.Rows*2-1, 1 do
        self.Frames[i].Tex:SetTexture(0.0, 0.0, 0.0, 1.0);
    end
end

function AutomatonIndicator:SetBindings()	
	for i=0,11,1 do
        if i<9 then bind = i+1 end
        if i==9 then  bind = 0 end
        if i==10 then bind = "-" end
        if i==11 then bind = "=" end
        -- первая строка
		SetOverrideBindingClick(self.Frame, true, "CTRL-" ..bind, "Automaton_"..i)
		SetOverrideBindingClick(self.Frame, true, "ALT-"  ..bind, "Automaton_"..(i+12))
		SetOverrideBindingClick(self.Frame, true, "SHIFT-"..bind, "Automaton_"..(i+24))
		-- не переписываем биндинги главной панели
		--SetOverrideBindingClick(self.Frame, true,           bind, "TB3_Ind"..(i+36))
        -- вторая строка
		SetOverrideBindingClick(self.Frame, true, "ALT-CTRL-"      ..bind, "Automaton_"..(i+48))
		SetOverrideBindingClick(self.Frame, true, "CTRL-SHIFT-"    ..bind, "Automaton_"..(i+60))
		SetOverrideBindingClick(self.Frame, true, "ALT-SHIFT-"     ..bind, "Automaton_"..(i+72))
		SetOverrideBindingClick(self.Frame, true, "ALT-CTRL-SHIFT-"..bind, "Automaton_"..(i+82))			
    end
end

function AutomatonIndicator:UnregisterAllSpells()
    -- сбрасываем счетчик спеллов
    self.SpellCount = 0
    -- очищаем карту индикаторов
    self.Spells = {}
	
	for i=0,35,1 do
		self.Frames[i]:SetAttribute("type","spell")
		self.Frames[i]:SetAttribute("spell",nil)
		self.Frames[i]:SetAttribute("unit","target")
	end
end

function AutomatonIndicator:UnregisterAllTargets()
    -- сбрасываем счетчик Целей
    self.TargetCount = 0
    -- очищаем карту индикаторов
    self.Targets = {}
	
	for i=48,87,1 do
		self.Frames[i]:SetAttribute("type","target")
		self.Frames[i]:SetAttribute("unit",nil)
	end
end

function AutomatonIndicator:RegisterSpell(ID)
	-- может быть забиндено только 36 спеллов
    if self.SpellCount==36 then
		print("Ошибка регистрации спеллов!!!")
        return
    end

    local name,rank = GetSpellInfo(ID)
    if rank~=nil and rank~="" then
        name = name.."("..rank..")"
    end

    -- биндим спелл
	self.Frames[self.SpellCount]:SetAttribute("type","spell")
	self.Frames[self.SpellCount]:SetAttribute("spell",name)
    self.Frames[self.SpellCount]:SetAttribute("unit","target")

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    self.Spells[ID] = self.SpellCount 
    self.SpellCount = self.SpellCount + 1
end


function AutomatonIndicator:RegisterTarget(name)

	-- может быть забиндено только 40 целей
    if self.TargetCount==40 then
		print("Ошибка регистрации целей!!!")
        return
    end
    print("зарегистрирован: ",name)

    -- биндим цель
	self.Frames[self.TargetCount+self.Rows]:SetAttribute("type","target")
    self.Frames[self.TargetCount+self.Rows]:SetAttribute("unit",name)

    -- прописываем в карте индикаторов, какой из них соответствует нашему спеллу
    self.Targets[name] = self.TargetCount+self.Rows
    self.TargetCount = self.TargetCount + 1
end

function AutomatonIndicator:CastSpell(ID)
    self:ClearControls()
	self.Frames[ self.Spells[ID] ].Tex:SetTexture(1.0, 1.0, 1.0, 1.0);
end

function AutomatonIndicator:Target(name)  
	self.Frames[ self.Targets[name] ].Tex:SetTexture(1.0, 1.0, 1.0, 1.0);
end
