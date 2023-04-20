-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

-- adding numbers
tree:add(1)
tree:add(-3)
tree:add(-4)
tree:add(5)

for i, v in tree:iterator() do
    print(i, v)
end
-- iteration will print:
-- 1    -4
-- 2    -3
-- 3    1
-- 4    5

print(tree.comparer(-1, 1)) -- the default comparer will emit -1 when a < b
print(tree.comparer(2, 1)) -- the default comparer will emit 1 when a > b
print(tree.comparer(15, 15)) -- the default comparer will emit 0 when a == b

-- now, creating an example
-- to showcase a binary tree
-- using a descending comparer
local function desc_comparer(a, b)
    return b - a
end

local tree_desc = binarytree(desc_comparer)

-- adding the same numbers in the previous example
tree_desc:add(1)
tree_desc:add(-3)
tree_desc:add(-4)
tree_desc:add(5)

for i, v in tree_desc:iterator() do
    print(i, v)
end
-- iteration will print:
-- 1    5
-- 2    1
-- 3    -3
-- 4    -4

print(tree_desc.comparer(-1, 1)) -- the descending comparer will emit 2
print(tree_desc.comparer(2, 1)) -- the descending comparer will emit -1
print(tree_desc.comparer(15, 15)) -- the descending comparer will emit 0