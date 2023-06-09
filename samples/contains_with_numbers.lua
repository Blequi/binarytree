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

print()
print(tostring( tree:contains(-8) )) -- false
print(tostring( tree:contains(1) )) -- true
print()