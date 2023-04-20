-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for strings
local tree = binarytree()

-- adding numbers to it
tree:add("e")
tree:add("c")
tree:add("d")
tree:add("c")
tree:add("b")
tree:add("a")

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
print(tostring( tree:contains("f") )) -- false
print(tostring( tree:contains("c") )) -- true
print()

print( tree:first() ) -- prints "a"
print( tree:last() ) -- prints "e"