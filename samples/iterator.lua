-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

-- adding numbers to it
tree:add(3)
tree:add(1)
tree:add(2)
tree:add(1)
tree:add(-1)
tree:add(0)

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()

for i, value in tree:iterator() do
    -- tree:iterator(false) or tree:iterator(nil)
    -- achieves the same result of calling
    -- tree:iterator()

    -- i holds the element's position in the sort order under forward direction
    -- value holds the element's value
    print(i, value)
end

-- iterating elements in backward direction
print()
print("backward iteration ... ")
print()
for i, value in tree:iterator(true) do
    -- i holds the element's position in the sort order under backward direction
    -- value holds the element's value
    print(i, value)
end
