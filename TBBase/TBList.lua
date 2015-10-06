TBBaseList = {}

function TBBaseList:Cast(key, target)
	if target then
		local cmd = {
				action = "spell",
				value = key,
				condition = target
			}
		self:Push(cmd)
	end
end

function TBBaseList:Focus(target)
	if target then
		local cmd = {
				action = "setfocus",
				condition = target
			}
		self:Push(cmd)
	end
end

function TBBaseList:Push(cmd)
	if self.command then return self end
	self.command = cmd
	return self  
end

function TBBaseList:Execute()

	function InnerSuccessCondiotion(cmd)  
		if cmd == nil then
			return 1
		end

		-- если мы хотим кастить в себя, и при этом в фокусе цель, которую нельзя лечить - не надо менять цель
		if cmd.action == "target" and UnitIsUnit("player", cmd.value) and UnitCanAttack("player", "target") then
			return 1
		end

		if cmd.action == "target" and UnitIsUnit("target", cmd.value) then
			return 1
		end

		if cmd.action == "assist" and UnitIsUnit("target", cmd.value) then
			return 1
		end  
	end	
	
	
	function InnerExecute(cmd)
		if InnerSuccessCondiotion(cmd.condition) then
			if cmd.action == "assist" then
				return "assist"
			end
			if cmd.action == "setfocus" then
				return "setfocus"
			end			
			return cmd.value
		else
			return InnerExecute(cmd.condition)
		end 
	end
	
	if self.command then
		return InnerExecute(self.command)
	end
end

function TBList()
	local result = {}
	setmetatable(result, {__index = TBBaseList})
	return result
end 
