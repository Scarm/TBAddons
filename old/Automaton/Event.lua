EventHandler = {}

function EventHandler:RegisterEvents(frame)
    for event,func in pairs(self.Events) do
	if event ~= "ANY" then
	    frame:RegisterEvent(event)
	end
    end
end

-- вариант для вызова множества функций для одного события, а так же для вызова функций на любое событие
function EventHandler:OnEvent(event,...)
	func = self.Events[event]
    self:Execute(func,event,...)
    anyFunc = self.Events["ANY"]
    self:Execute(anyFunc,event,...)
end

function EventHandler:Execute(func,event,...)
    if type(func) == "table" then
	for key,f in pairs(func) do
	    self.Owner[f](self.Owner,event,...)	  
	end      
    elseif func~=nil then		    
	    self.Owner[func](self.Owner,event,...)  
    end
end

function EventHandler:Create(owner,events)
    result = {}
    result.Owner = owner
    result.Events = events 
    setmetatable(result, {__index = self})
    return result    
end

--[[
function CreateEventHandler(owner,events)
    result = {}
    result.Owner = owner
    result.Events = events 
    setmetatable(result, {__index = EventHandler})
    return result
end


Owner = {}
function Owner:OnFirst()
print("OnFirst()")
end

function Owner:OnFirst2()
print("OnFirst2()")
end

function Owner:OnAny()
print("OnAny()")
end

Frame = {}
function Frame:RegisterEvent(event)
print("register event",event)
end

eh = CreateEventHandler(Owner,{
["First"] = {"OnFirst","OnFirst2"},
["Second"] = "OnSecond",
["Third"] = "OnThird",
["ANY"] = "OnAny"
})

eh:RegisterEvents(Frame)
eh:OnEvent("First",...)

--]]