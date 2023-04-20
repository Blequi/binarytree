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

print(tree.distinct) -- prints true

local tree2 = binarytree()

-- adding repeated elements without any error raising.
tree2:add(1)
tree2:add(2)
tree2:add(1)

print(tree2.distinct) -- prints nil