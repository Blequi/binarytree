-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

-- adding numbers to it
tree:add(3)
tree:add(1)

-- 2 will be printed
print(tree.count)

-- adding more numbers
tree:add(2)
tree:add(1)
tree:add(-1)
tree:add(0)

-- 6 will be printed
print(tree.count)

-- removes all the elements from the tree
tree:clear()

-- 0 will be printed
print(tree.count)