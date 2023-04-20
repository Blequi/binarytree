-- loading the module
local binarytree = require("binarytree")

-- comparer to sort collaborators by name
local function collaborators_name_comparer(a, b)
    local a_name = a.name
    local b_name = b.name

    return (a_name == b_name) and 0 or (a_name < b_name and -1 or 1)
end

-- creating a binary tree to hold collaborators sorted by name
local collaborators = binarytree(collaborators_name_comparer)

-- adding collaborators
collaborators:add({name = 'Bob', age = 21})
collaborators:add({name = 'Alice', age = 34})
collaborators:add({name = 'John', age = 32})
collaborators:add({name = 'James', age = 20})

-- iterates collaborators in forward direction
for i, e in collaborators:iterator() do
    print(i, e.name, e.age)
end

-- will print: 
-- 1    Alice   34
-- 2    Bob     21
-- 3    James   20
-- 4    John    32