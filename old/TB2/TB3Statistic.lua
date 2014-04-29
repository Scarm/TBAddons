print("TB3Statistic")
TB3Statistic = {}
print(TB3Statistic)
function TB3Statistic:Reset()
	local info = _G["TB3StatisticInfoFrame"]
	
	info:SetHeight( TB3Group.Num*20 )	
end