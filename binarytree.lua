local node = {}
node.__index = node

function node:get_parent()
    return self._parent
end

function node:set_parent(value)
    self._parent = value
end

function node:get_left()
    return self._left
end

function node:set_left(value)
    self._left = value
end

function node:get_right()
    return self._right
end

function node:set_right(value)
    self._right = value
end

function node:get_value()
    return self._value
end

function node.new(value)
    local o = {}
    o.__index = o
    o._value = value

    return setmetatable(o, node)
end

local function default_comparer(a, b)
    local result = nil
    if (a == b) then
        result = 0
    elseif (a < b) then
        result = -1
    else
        result = 1
    end
    return result
end

local function clear(self)
    self.count = 0
    self._root = nil
end

local function get_left_most(n, depth)
    local current = n:get_left()
    local newdepth = depth or 0

    if (current ~= nil) then
        newdepth = newdepth + 1
        while (current:get_left() ~= nil) do
            newdepth = newdepth + 1
            current = current:get_left()
        end
    end
    
    return current, newdepth
end

local function get_right_most(n, depth)
    local current = n:get_right()
    local newdepth = depth or 0

    if (current ~= nil) then
        newdepth = newdepth + 1
        while (current:get_right() ~= nil) do
            newdepth = newdepth + 1
            current = current:get_right()
        end
    end
    
    return current, newdepth
end

local forward_iter_subtree
forward_iter_subtree = function(self, state, n, depth)
    local np = n:get_parent()
    local left, left_depth = get_left_most(n, depth)
    if (left == nil) then
        local parent = n
        state.i = state.i + 1
        coroutine.yield(state.i, parent:get_value())

        local right = parent:get_right()

        if (right ~= nil) then
            forward_iter_subtree(self, state, right, depth + 1)
        end
    else
        state.i = state.i + 1
        coroutine.yield(state.i, left:get_value())

        local right_of_left = left:get_right()
        if (right_of_left ~= nil) then
            forward_iter_subtree(self, state, right_of_left, left_depth + 1)
        end

        local parent = left:get_parent()

        while (left_depth > depth) do
            state.i = state.i + 1
            coroutine.yield(state.i, parent:get_value())

            local right = parent:get_right()

            if (right ~= nil) then
                forward_iter_subtree(self, state, right, left_depth)
            end

            parent = parent:get_parent()

            left_depth = left_depth - 1
        end
    end
end

local function forward_iterator(self)
    return coroutine.wrap(
        function()
            local root = self._root
            
            if (root ~= nil) then
                local state = { i = 0 }
        
                local left = root:get_left()
        
                if (left ~= nil) then
                    forward_iter_subtree(self, state, left, 1)
                end
                
                state.i = state.i + 1
                coroutine.yield(state.i, root:get_value())
        
                local right = root:get_right()
        
                if (right ~= nil) then
                    forward_iter_subtree(self, state, right, 1)
                end
            end
        end
    )
end

local backward_iter_subtree
backward_iter_subtree = function(self, state, n, depth)
    local np = n:get_parent()
    local right, right_depth = get_right_most(n, depth)
    if (right == nil) then
        local parent = n
        state.i = state.i + 1
        coroutine.yield(state.i, parent:get_value())

        local left = parent:get_left()

        if (left ~= nil) then
            backward_iter_subtree(self, state, left, depth + 1)
        end
    else
        state.i = state.i + 1
        coroutine.yield(state.i, right:get_value())

        local left_of_right = right:get_left()
        if (left_of_right ~= nil) then
            backward_iter_subtree(self, state, left_of_right, right_depth + 1)
        end

        local parent = right:get_parent()

        while (right_depth > depth) do
            state.i = state.i + 1
            coroutine.yield(state.i, parent:get_value())

            local left = parent:get_left()

            if (left ~= nil) then
                backward_iter_subtree(self, state, left, right_depth)
            end

            parent = parent:get_parent()

            right_depth = right_depth - 1
        end
    end
end

local function backward_iterator(self)
    return coroutine.wrap(
        function()
            local root = self._root
            
            if (root ~= nil) then
                local state = { i = 0 }
        
                local right = root:get_right()
        
                if (right ~= nil) then
                    backward_iter_subtree(self, state, right, 1)
                end
                
                state.i = state.i + 1
                coroutine.yield(state.i, root:get_value())
        
                local left = root:get_left()
        
                if (left ~= nil) then
                    backward_iter_subtree(self, state, left, 1)
                end
            end
        end
    )
end

local function iterator(self, backward)
    return backward and backward_iterator(self) or forward_iterator(self)
end

local function find_node(self, value)
    local found = false
    local element = nil
    local root = self._root

    if (root ~= nil) then
        local n = root
        while (n ~= nil) do
            local comparison = self.comparer(n:get_value(), value)
            if (comparison < 0) then
                local r = n:get_right()
                if (r == nil) then
                    n = nil
                else
                    n = r
                end
            elseif (comparison > 0) then
                local l = n:get_left()
                if (l == nil) then
                    n = nil
                else
                    n = l
                end
            else
                found = true
                element = n
                n = nil
            end
        end
    end

    return found, element
end

local function contains(self, value)
    local found, element = find_node(self, value)
    return found
end

local function empty(self)
    return self.count == 0
end

local function remove_node(self, n)
    self.count = self.count - 1

    local parent = n:get_parent()
    local left = n:get_left()
    local right = n:get_right()

    if (left ~= nil) then
        local left_rm = get_right_most(left)
        
        if (parent == nil) then
            left:set_parent(nil)
            self._root = left
        else
            local parent_left = parent:get_left()
            if (parent_left ~= nil and self.comparer(parent_left:get_value(), n:get_value()) == 0) then
                parent:set_left(left)
            else
                parent:set_right(left)
            end

            left:set_parent(parent)
        end

        if (right ~= nil) then
            if (left_rm == nil) then
                right:set_parent(left)
                left:set_right(right)
            else
                right:set_parent(left_rm)
                left_rm:set_right(right)
            end
        end
    elseif (right ~= nil) then

        if (parent == nil) then
            right:set_parent(nil)
            self._root = right
        else
            local parent_left = parent:get_left()
            if (parent_left ~= nil and self.comparer(parent_left:get_value(), n:get_value()) == 0) then
                parent:set_left(right)
            else
                parent:set_right(right)
            end

            right:set_parent(parent)
        end
    else
        if (parent == nil) then
            self._root = nil
        else
            local parent_left = parent:get_left()
            if (parent_left ~= nil and self.comparer(parent_left:get_value(), n:get_value()) == 0) then
                parent:set_left(nil)
            else
                parent:set_right(nil)
            end
        end
    end
end

local function remove(self, value, all)
    local counter = 0
    local found, n = find_node(self, value)
    if (all) then
        while (found)  do
            remove_node(self, n)
            counter = counter + 1
            found, n = find_node(self, value)
        end
    else
        if (found) then
            remove_node(self, n)
            counter = counter + 1
        end
    end
    return counter
end

local function first(self)
    if (self:empty()) then
        error("Collection is empty", 2)
    end
    local result = nil
    for i, v in self:iterator() do
        result = v
        break
    end
    return result
end

local function last(self)
    if (self:empty()) then
        error("Collection is empty", 2)
    end
    local result = nil
    for i, v in self:iterator(true) do
        result = v
        break
    end
    return result
end

local function add(self, value)
    local root = self._root

    if (root == nil) then
        root = node.new(value)
        self._root = root
    else
        local n = root
        while (n ~= nil) do
            local comparison = self.comparer(n:get_value(), value)
            if (comparison < 0) then
                local r = n:get_right()
                if (r == nil) then
                    r = node.new(value)
                    n:set_right(r)
                    r:set_parent(n)
                    n = nil
                else
                    n = r
                end
            elseif (comparison > 0) then
                local l = n:get_left()
                if (l == nil) then
                    l = node.new(value)
                    n:set_left(l)
                    l:set_parent(n)
                    n = nil
                else
                    n = l
                end
            else
                if (self.distinct) then
                    error("This value is already in the collection. This collection was configured to allow only distinct elements.", 2)
                else
                    local current = node.new(value)
                    
                    local l = n:get_left()
                    if (l == nil) then
                        current:set_parent(n)
                        n:set_left(current)
                    else
                        local r = n:get_right()
                        if (r == nil) then
                            current:set_parent(n)
                            n:set_right(current)
                        else
                            local right_of_left = get_right_most(l)
                        
                            if (right_of_left == nil) then
                                current:set_parent(l)
                                l:set_right(current)
                            else
                                current:set_parent(right_of_left)
                                right_of_left:set_right(current)
                            end
                        end
                    end
    
                    n = nil
                end
            end
        end
    end

    self.count = self.count + 1
end

local function create(comparer, distinct)
    if (comparer ~= nil) then
        local tcomparer = type(comparer)
        if (tcomparer ~= 'function') then
            error(("A comparer function was expected, but got %q."):format(tcomparer), 2)
        end
    end

    local data = nil
    data = {
        
        -- properties
        comparer = comparer or default_comparer,
        count = 0,
        distinct = distinct,

        -- methods
        add = function(self, value) add(data, value) end,
        clear = function(self) clear(data) end,
        contains = function(self, value) return contains(data, value) end,
        empty = function(self) return empty(data) end,
        first = function(self) return first(data) end,
        iterator = function(self, backward) return iterator(data, backward) end,
        last = function(self) return last(data) end,
        remove = function(self, value, all) return remove(data, value, all) end
    }

    return setmetatable({}, {
        __index = data,
        __newindex = function(self, key, value)
            error("This object cannot be extended.", 2)
        end,
        __metatable = false
    })
end

return create