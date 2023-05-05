-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance to sort elements by price
local fruits = binarytree(function(a, b)
    return a.price - b.price
end)

-- adding "fruit objects" to it
fruits:add({name = 'orange', price = 20})
fruits:add({name = 'apple', price = 25})
fruits:add({name = 'banana', price = 15})

-- print the number of elements in the binary tree
print(fruits.count)

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()
for i, value in fruits:iterator() do
    -- i holds the element's position in the sort order under forward direction
    -- value holds the element's value
    print(i, value.name, value.price)
end

-- iterating elements in backward direction
print()
print("backward iteration ... ")
print()
for i, value in fruits:iterator(true) do
    -- i holds the element's position in the sort order under backward direction
    -- value holds the element's value
    print(i, value.name, value.price)
end

print()
print(tostring( fruits:contains({price = 10}) )) -- false (is not found by price)
print(tostring( fruits:contains({price = 15}) )) -- true (is found by price)
print()

print( fruits:first().name ) -- prints "banana"
print( fruits:last().name ) -- prints "apple"