Accumulator = {}

function Accumulator:Push(time, value)
    if self.tail then
    self.tail.Next = 
    {
        Time = time,
        Value = value
    }
    self.tail = self.tail.Next
    else    
    self.tail = 
    {
        Time = time,
        Value = value
    }
    self.head = self.tail
    end
end

function Accumulator:Reset()
    self.head = nil
    self.tail = nil    
end

function Accumulator:InitStats()
   self.Stats = {}
   local last = 0
   for k,v in pairs(self.TimeSteps) do
       self.Stats[v] = 0
       if v > last then
           last = v
       end
   end
   return last
end

function Accumulator:Evaluate(time)
    local last = self:InitStats()

    while self.head and self.head.Time + last < time do
        self.head = self.head.Next       
    end

    local it = self.head
    while it do
        for k,v in pairs(self.TimeSteps) do
            if it.Time + v > time then
                self.Stats[v] = self.Stats[v] + it.Value
            end
        end           
        it = it.Next
    end
end

function Accumulator:List()
    local it = self.head
    while it do
        print("["..it.Time.."]="..it.Value)          
        it = it.Next
    end   
end

function Accumulator:Create(timeSteps)
    result = {}
    --table.sort(timeSteps)
    result.TimeSteps = timeSteps
    setmetatable(result, {__index = self})
    result:InitStats()
    return result    
end



--[[

acc = Accumulator:Create({10,20,30})


]]