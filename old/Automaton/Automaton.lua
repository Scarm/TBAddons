
Automaton = CreateFrame("Frame","AutomatonEventFrame",UIParent)
Automaton.Classes = {}
Automaton.EventHandler = EventHandler:Create(Automaton, 
    {
        ["PLAYER_LOGIN"] = "OnPlayerLogin",
        ["UNIT_SPELLCAST_START"] = "OnSpellcast",
        ["UNIT_SPELLCAST_SENT"] = "ClearIndicators",
        ["PLAYER_TARGET_CHANGED"] = "ClearIndicators",
        ["UNIT_SPELLCAST_SUCCEEDED"] = "OnSpellcast",
        ["ACTIVE_TALENT_GROUP_CHANGED"] = "OnTalentChanged"
    })
Automaton.EventHandler:RegisterEvents(Automaton)     
    
--Регистрация нового бота в системе
--этот метод должен вызывать каждый бот последней строкой файла
function Automaton:Register(bot)
    print("Automaton:Register()")
   
    if bot == nil then
        print("Передан пустой бот")
        return
    end
    if bot.Class == nil then
        print("Не задан класс бота 'Class'")
        return
    end
       
    if bot.Name == nil then
        print("Не задано название бота 'Name'")
        return
    end
    
    if Automaton.Classes[bot.Class][bot.Name] then
        print("Бот класса ",bot.Class," с именем ",bot.Name," уже зарегистрирован")
        return        
    end

    if type(bot.Talents) ~= "number" then
        print("Не задана специализация бота, либо указано не числовое значение 'Talents'")
        return
    end
    
        
    if type(bot.Spells) ~= "table" then
        print("Не заданы спеллы бота 'Spells'")
        return
    end
    
    if type(bot.Buttons) ~= "table" then
        print("Не заданы кнопки бота 'Buttons'")
        return
    end 
    
    if type(bot.OnUpdate) ~= "function" then
        print("Не задан обработчик события 'OnUpdate' бота")
        return        
    end
    
    --для первого бота каждого класса создаем свою таблицу
    if Automaton.Classes[bot.Class] == nil then
        Automaton.Classes[bot.Class] = {}
    end

    Automaton.Classes[bot.Class][bot.Name] = bot
end

--[[
function Automaton:OnLoad(eventFrame)
    print("Automaton:OnLoad")
    self.EventHandler:RegisterEvents(eventFrame)    
end
--]]

function Automaton:OnEvent(event,...)
    --перенаправляем вызов в EventHandler для маршрутизации события
    self.EventHandler:OnEvent(event,...)  
end


function Automaton:OnSpellcast(...)
    --если прошло событие каста спелла - надо удалить спелл из очереди
    local id = select(6,...)
    self:CancelSpell(id)
end

function Automaton:ClearIndicators(...)
    --при смене цели, либо при отсылке спелла становится ясно, что кнопка прожата
    -- значит нужно погасить индикатор
    self.Indicator:ClearControls()
end

--опредение класса и талантов, попытка сключить соответствующий спек
function Automaton:OnPlayerLogin()
    self.timer = GetTime()
    local name,class = UnitClass("player")
    self.Class = class
    print("Загружаются боты для класса",name)

    self:InitSavedVariables()   
    self:InitClassBot()
end

-- при смене талантов бот должен поменяться
function Automaton:OnTalentChanged()
    self:InitClassBot()
end

-- если переменные не созданы - создадим сохраняемы переменные
function Automaton:InitSavedVariables()
    if Automaton_vars == nil then
        Automaton_vars = {}
    end

    -- переменная создается на каждого перса, у перса всегда один класс
    --[[
    if Automaton_vars[self.Class] == nil then
        Automaton_vars[self.Class] = {}
    end
    -- это быстрый путь для своих переменных
    self.Vars = Automaton_vars[self.Class]
    --]]
end

-- определяем класс и спек, пробуем найти для них бота
-- если нашли - устанавливаем
function Automaton:InitClassBot()
    if self.Classes[self.Class] == nil then
        print("Не обнаружено ботов для этого класса")
        return
    end

    -- бота чистим всегда, а устанавливаем - только если нашли подходящего
    self:ClearSpec()   
    local currentTalents = GetSpecialization()
    for key,value in pairs(self.Classes[self.Class]) do
        if value.Talents == currentTalents then
            return self:SetSpec(key)
        end
    end
    print("Не найдено бота для этого набора талантов")
end

-- очистить текущий спек
function Automaton:ClearSpec()
    print("ClearSpec") 
    self.Spec = nil
    self.Indicator:UnregisterAllSpells()
    self.Panel:RemoveAllButtons()    
end

-- устанавливаем спек:
-- регистрируем нужные спеллы и кнопки, присваиваем поле Spec
function Automaton:SetSpec(spec)
    print("SetSpec",spec)
    self.Spec = self.Classes[self.Class][spec]
    print(self.Spec,self.Spec.Name,self.Spec.Lag)
    
    for key,value in pairs(self.Spec.Spells) do
        self.Indicator:RegisterSpell(value)
    end

    for key,value in pairs(self.Spec.Buttons) do
        self.Panel:AddButton(value)
    end
end


-- удаление спелла из очереди
function Automaton:CancelSpell(spellID)
    self.Query:Remove("spell", spellID)
    -- очищать индикаторы надо, иначе иногда остается зажженым удаленный спелл 
    self:ClearIndicators()
end

-- этот метод - для кастов через очередь спелов
-- каст спеллов из очереди происходи первым
function Automaton:PushSpell(spellID,target)  
    self.Query:Add("spell", spellID, target) 
end

-- узнать, есть ли спелл в очереди
function Automaton:GetSpell(spellID)
   return self.Query:Get("spell", spellID) 
end

-- основная итерация бота
-- запращивает каст из очереди, в случае если очередь пустая - просит спелл у бота
function Automaton:OnUpdate(elapsed)
    if self.Spec == nil then
        return
    end
    -- тут устанавливается интервал запроса бота
    local now = GetTime()
    if now - self.timer < 0.1 then
        return
    end
    self.timer = now
   
    local action,key,target = self.Query:First()
    -- если в очереди спелл который можно сейчас прокастовать - берем его, иначе запрашиваем спелл у бота
    if not (action and self.Spec:CanUseId(key,target)) then       
        action,key,target = self.Spec:OnUpdate()
    end     
    
    --проверка на "spell" заложена для возможности реализации использования предметов
    -- в этом методе индикаторы только зажигаются, тушатся они при посылке на сервер спелла и смене цели
    if action == "spell" then
        
        if not self:Targetting(target) then
            return self.Indicator:CastSpell(key)
        end       
    end
    
end

-- 
function Automaton:Targetting(target)
    -- если указана цель, не являющаяся текущей целью - значит мы можем на неё фокуситься
    if target and target ~= "target" then    
        -- сейчас поддерживается только таргетинг на членов группы или рейда       
        if self.Raid:Contains(target) and UnitIsUnit(target, "target")~=1 then            
            -- если цель - игрок, а текущая цель враждебна - не надо менять цель
            if UnitIsUnit(target, "player") and UnitCanAssist("player","target")~=1 then
                return nil
            else
                self.Indicator:Target(target)
                return 1
            end
        end
    end 
end


--[[ вспомогательные функции, для отладки
function Automaton:LagAnalisysStart(event,...)
    -- если кастов еще не было, или последний каст был более 10 сек назад 
    -- - значит надо сбросить начальное время замера 
    if self.AnalisysCastStart == nil then
        self.AnalisysTimeTotal = 0
    	print("Первый запуск счетчика")
    end

    if self.AnalisysCastStart and self.AnalisysCastStart < (GetTime()-10)*1000 then
    	self.AnalisysTimeStart = nil
        self.AnalisysTimeTotal = 0
    	print("сбросили счетчик")
    end
    
    -- если прошел каст, а начальное время замера не выставлено - значит это первый каст эксперимента
    if self.AnalisysTimeStart == nil then
	self.AnalisysTimeStart = GetTime()
    end
    
    self.AnalisysCastStart,self.AnalisysCastEnd = select(5,UnitCastingInfo("player")) 
    
    local castTime = (self.AnalisysCastEnd - self.AnalisysCastStart)/1000
    self.AnalisysTimeTotal = self.AnalisysTimeTotal + castTime
    
    local total = GetTime() - self.AnalisysTimeStart + castTime
    
    
    print("процент активности: ", self.AnalisysTimeTotal/total )
end

--]]




