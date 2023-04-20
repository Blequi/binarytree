-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

-- adding numbers to it
tree:add(3)
tree:add(8)
tree:add(2)
tree:add(8)
tree:add(-1)
tree:add(0)
tree:add(2)
tree:add(5)
tree:add(2)

-- removing a single occurrence of 8 from the binary tree
local n1 = tree:remove(8)

print(n1) -- prints 1

-- removing all occurrences of 2 from the binary tree
local n2 = tree:remove(2, true)

print(n2) -- prints 3

-- tries to remove 53 from the tree, but it is not there
local n3 = tree:remove(53)

print(n3) -- prints 0

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()

for i, value in tree:iterator() do
    -- i holds the element's position in the sort order under forward direction
    -- value holds the element's value
    print(i, value)
end