TBEventFrame.EventRoutingMap = {}

function TBRouteEvent(event,...)
	if TBEventFrame.EventRoutingMap[event] then
		for obj,functions in pairs(TBEventFrame.EventRoutingMap[event]) do
			for func, val in pairs(functions) do
				if _G[func] then
					_G[func](obj, event,...)
				else
					obj[func](obj, event,...)
				end
			end
		end
	end
end

function TBSubscribeEvent(self, event, func)
	if TBEventFrame:IsEventRegistered(event) == false then
		TBEventFrame:RegisterEvent(event)
	end
	
	if TBEventFrame.EventRoutingMap[event] == nil then
		TBEventFrame.EventRoutingMap[event] = {}
	end
	
	if TBEventFrame.EventRoutingMap[event][self] == nil then
		TBEventFrame.EventRoutingMap[event][self] = {}
	end	
	TBEventFrame.EventRoutingMap[event][self][func] = 1	
end