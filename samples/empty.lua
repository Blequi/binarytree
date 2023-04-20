-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

print(tree:empty()) -- prints true

-- adding numbers to it
tree:add(3)
tree:add(1)

print(tree:empty()) -- prints false