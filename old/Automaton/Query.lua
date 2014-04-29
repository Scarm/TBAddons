Query = {}
Automaton.Query = Query

function Query:Get(action, key) 
    local i = self.head
    while i do
    if i.Key == key and i.Action == action then
        return i.Action, i.Key, i.Value
    end
    i = i.Next
    end 
end

function Query:First(predicate)
    if predicate == nil then
    if self.head then
        return self.head.Action, self.head.Key, self.head.Value
    else
        return nil
    end
    end


    local i = self.head
    while i do
    if predicate(i.Key, i.Action, i.Value) then
        return i.Action, i.Key, i.Value
    end
    i = i.Next
    end    
end

function Query:Add(action, key, value)
    if self:Get(action, key) then
        return
    end
    if self.tail then
        self.tail.Next = 
        {
            Key = key,
            Action = action,
            Value = value
        }
        self.tail = self.tail.Next
        else    
        self.tail = 
        {
            Key = key,
            Action = action,
            Value = value
        }
        self.head = self.tail
    end
    
end

function Query:Remove(action, key)
    if self.head then
        i = self.head
        local prev
        while i do
            if i.Key == key and i.Action == action then            
                if prev then
                    prev.Next = i.Next
                else
                  self.head = i.Next
                end
                if i.Next== nil then
                    self.tail = prev
                end
                  
                return i.Key,i.Value
            end
            prev = i
            i = i.Next
        end      
    end
end

function Query:List()
    i = self.head
    while i do
        print(i.Action, i.Key, i.Value)
        i = i.Next
    end
end





