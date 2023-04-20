-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers,
-- but ensuring elements are distinct
local tree = binarytree(nil, true)

-- adding numbers to it
tree:add(3)
tree:add(1)
tree:add(2)

-- trying to add an element already in the tree will raise an error, because distinct is activated.
if (not pcall(function()
    tree:add(1)
end)) then
    print()
    print("unable to add 1, because it is already in the tree and distinct elements are enforced.")
    print()
end

tree:add(-1)
tree:add(0)

-- print the number of elements in the binary tree
print(tree.count)

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()
for i, value in tree:iterator() do
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

print()
print(tostring( tree:contains(-8) )) -- false
print(tostring( tree:contains(1) )) -- true
print()

print( tree:first() ) -- prints -1
print( tree:last() ) -- prints 3