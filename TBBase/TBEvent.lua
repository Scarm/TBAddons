TBEventFrame.EventRoutingMap = {}

function TBRouteEvent(event,...)
	if TBEventFrame.EventRoutingMap[event] then
		for self,functions in pairs(TBEventFrame.EventRoutingMap[event]) do
			for func, val in pairs(functions) do
				_G[func](self, event,...)
			end
		end
	end
end

function TBSubscribeEvent(self, event, func)
	--print("register event:", event)
	if TBEventFrame:IsEventRegistered(event) == false then
		TBEventFrame:RegisterEvent(event)
		--print("registered!")
	end
	
	if TBEventFrame.EventRoutingMap[event] == nil then
		TBEventFrame.EventRoutingMap[event] = {}
	end
	
	if TBEventFrame.EventRoutingMap[event][self] == nil then
		TBEventFrame.EventRoutingMap[event][self] = {}
	end	
	TBEventFrame.EventRoutingMap[event][self][func] = 1	
end