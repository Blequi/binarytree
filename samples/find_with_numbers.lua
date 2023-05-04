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

-- the first return value
-- is a boolean (false 'or' true)
-- while the second is the element
-- in the tree in the case the element
-- was there.
local found, element = tree:find(3)

print(found, element) -- prints: true, 3 

-- for elements out of the tree,
-- the response is always: false, nil
found, element = tree:find(10)

print(found, element) -- prints: false, nil