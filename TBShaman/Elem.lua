ShamanElem = {
			["Unique"] = {
			},
			["Id"] = 1,
			["Spells"] = {
				["Выброс лавы"] = 51505,
				["Огненный шок"] = 8050,
				["Пронизывающий ветер"] = 57994,
				["Молния"] = 403,
				["Гром и молния"] = 51490,
				["Высвободить чары стихий"] = 73680,
				["Земной шок"] = 8042,
				["Щит молний"] = 324,
			},
			["Buffs"] = {
			},
			["Class"] = "SHAMAN",
		}
	
--function TBCanUse(name, target)	
--function TBCast(name,target)
--function TBBuff(name,isMine,target)   
--function TBDebuff(name,isMine,target)
--function TBBuffElapsed(name,isMine,target)
--function TBBuffStack(name,isMine,target)
--function TBDebuffElapsed(name,isMine,target)
--function TBDebuffStack(name,isMine,target)
--function TBCanInterrupt(target)

--UnitPower(Player,15)
		
function ShamanElem:OnUpdate()
	if IsMounted() then return end

	if TBCanInterrupt("target") and TBCanUse("Пронизывающий ветер","target") then
		return TBCast("Пронизывающий ветер","target")
	end
	
	if TBBuff("Щит молний", 1,"player")==nil and TBCanUse("Щит молний","player") then
		return TBCast("Щит молний","player")
	end	
	
	
	if TBDebuff("Огненный шок",1,"target")== nil and TBCanUse("Огненный шок","target") and TBCanUse("Высвободить чары стихий","target") and UnitCanAttack("player", "target") then           
		return TBCast("Высвободить чары стихий","target")
	end
		
	
	if TBDebuff("Огненный шок",1,"target")== nil and TBCanUse("Огненный шок","target") then           
		return TBCast("Огненный шок","target")
	end	
	
	if TBDebuff("Огненный шок",1,"target") and TBCanUse("Выброс лавы","target") then           
		return TBCast("Выброс лавы","target")
	end
	
	if TBBuffStack("Щит молний", 1,"player")==7 and TBCanUse("Земной шок","target") then
		return TBCast("Земной шок","target")
	end	

	if TBCanUse("Молния","target") then           
		return TBCast("Молния","target")
	end	
end
		
		
		
TBRegister(ShamanElem)