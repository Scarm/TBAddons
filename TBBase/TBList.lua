TBBaseList = {}

function TBBaseList:Push(cmd)
	if self.command then return self end
	self.command = cmd
	return self  
end

function TBBaseList:Execute()

	function SuccessCondiotion(cmd)  
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
		if SuccessCondiotion(cmd.condition) then
			return cmd.value
		else
			return Execute(cmd.condition)
		end 
	end
	
	if self.command then
		InnerExecute(self.command)
	end
end

function TBList()
	local result = {}
	setmetatable(result, {__index = TBBaseList})
	return result
end 
