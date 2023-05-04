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

-- the interesting use case for this 'find' function
-- targets objects. For instance, if later in the code
-- we only have the collaborator's name, it is possible
-- to retrieve the whole information about person
-- from the original element added to the tree.
local found_bob, bob = collaborators:find({name = 'Bob'})

print(found_bob, bob.name, bob.age) -- prints: true Bob 21

local found_john, john = collaborators:find({name = 'John'})

print(found_john, john.name, john.age) -- prints: true  John    32

local found_olivia, olivia = collaborators:find({name = 'Olivia'})

print(found_olivia, olivia) -- prints: false, nil