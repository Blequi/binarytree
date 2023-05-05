# binarytree

[![Build status](https://ci.appveyor.com/api/projects/status/w0x7xs00prvuxxai?svg=true)](https://ci.appveyor.com/project/Blequi/binarytree)

[![Coverage Status](https://coveralls.io/repos/github/Blequi/binarytree/badge.svg)](https://coveralls.io/github/Blequi/binarytree)

## Table of Contents

* [Summary](#summary)
* [Description](#description)
    * [Overview](#overview)
    * [Time Complexity](#time-complexity)
* [Installation](#installation)
* [Usage](#usage)
    * [Example with numbers](#example-with-numbers)
    * [Example with strings](#example-with-strings)
    * [Examples with objects](#examples-with-objects)
    * [Example ensuring distinct elements](#example-ensuring-distinct-elements)
* [Constructors](#constructors)
* [Properties](#properties)
    * [comparer](#comparer)
    * [count](#count)
    * [distinct](#distinct)
* [Methods](#methods)
    * [add](#add)
    * [clear](#clear)
    * [contains](#contains)
    * [empty](#empty)
    * [find](#find)
    * [first](#first)
    * [iterator](#iterator)
    * [last](#last)
    * [remove](#remove)
* [Unit Tests](#unit-tests)
* [Code Coverage](#code-coverage)
* [Change Log](#change-log)

## Summary

**binary tree** data structure written in pure Lua

## Description

### Overview

In computer science, (sorted) binary tree is
a data structure meant to achieve quick lookup,
insertion and removal of elements.
In order to do so, elements stay sorted
according to a certain comparison function.

### Time complexity

| Algorithm | Average  | Worst |
|-----------|----------|-------|
| Search    | O(log n) | O(n)  |
| Insert    | O(log n) | O(n)  |
| Delete    | O(log n) | O(n)  |

## Installation

* If ```luarocks``` is installed on your operating system, just issue the command:
```
[sudo] luarocks install binarytree
```
* Alternatively, simply drop the file *binarytree.lua* on your project path and ```require("binarytree")``` it.

## Usage

### Example with numbers

```lua
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
print(tostring( tree:contains(-8) )) -- false
print(tostring( tree:contains(1) )) -- true
print()

print( tree:first() ) -- prints -1
print( tree:last() ) -- prints 3
```

### Example with strings
```lua
-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for strings
local tree = binarytree()

-- adding strings to it
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
```

### Examples with objects

* First example: sort by fruit's price.
```lua
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
```
* Second example: sort by collaborator's name.
```lua
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
```

### Example ensuring distinct elements
```lua
-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using
-- the default comparer for numbers (first parameter = nil),
-- but ensuring elements are distinct (second parameter = true)
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
print(tostring( tree:contains(-8) )) -- false
print(tostring( tree:contains(1) )) -- true
print()

print( tree:first() ) -- prints -1
print( tree:last() ) -- prints 3
```

## Constructors
* *Description*: creates a new binary tree's instance.
* *Signature*: ```(comparer, distinct)```
    * *comparer (function - can be nil)*: A function to compare elements. This function takes parameters ```a```, ```b``` and issues an integer comparing them (```(a, b) -> integer```). The basic idea is that:
        * ```a == b -> 0```
        * ```a < b -> a negative number```
        * ```a > b -> a positive number```
        * First remark: Everytime the comparer returns 0, this library assumes that ```a == b```.
        * Second Remark: It is common to use
        ```lua
        function(a, b) return a - b end
        ```
        as a comparer for numbers. On the other hand, for strings, an option for the (case-sensitive) comparer function would be
        ```lua
        function(a, b) return (a == b) and 0 or ((a < b) and -1 or 1) end
        ```
        * If nil is passed, the following default comparer function is used
        ```lua
        function(a, b) return (a == b) and 0 or ((a < b) and -1 or 1) end
        ```
    * *distinct (object - can be nil)*: flag indicating where all elements to be added should be distinct or not. Take a look: [example ensuring distinct elements](#example-ensuring-distinct-elements)
    * *return (binary tree)*: a new binary tree's instance
* *Exception*: will raise error if ```comparer``` is not nil or a function.
* *Example*:
```lua
-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

tree:add(1)
tree:add(-5)
tree:add(4)

for i, v in tree:iterator() do
    print(i, v)
end

-- iteration will print:
-- 1    -5
-- 2    1
-- 3    4

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
```

## Properties

### comparer
* *Description*: A function to compare elements, assigned to the binary tree upon creation. This function takes parameters ```a```, ```b``` and issues an integer comparing them (```(a, b) -> integer```). The basic idea is that:
    * ```a == b -> 0```
    * ```a < b -> a negative number```
    * ```a > b -> a positive number```
    * First remark: Everytime the comparer returns 0, this library assumes that ```a == b```.
    * Second Remark: It is common to use
    ```lua
    function(a, b) return a - b end
    ```
    as a comparer for numbers. On the other hand, for strings, an option for the (case-sensitive) comparer function would be
    ```lua
    function(a, b) return (a == b) and 0 or ((a < b) and -1 or 1) end
    ```
    * If nil is passed, the following default comparer function is used
    ```lua
    function(a, b) return (a == b) and 0 or ((a < b) and -1 or 1) end
    ```
* *Signature*: ```compare```
    * *return (function)*
* *Example*:
```lua
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
```

### count

* *Description*: the number of elements in the binary tree.
* *Signature*: ```count```
    * *return (integer)*
* *Example*:
```lua
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
``` 

### distinct
* *Description*: a flag indicating whether elements in the binary tree should be distinct or not.
* *Signature*: ```distinct```
    * *return (object - can be nil)*
* *Example*:
```lua
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
```

## Methods

### add
* *Description*: adds an element to the binary tree.
* *Signature*: ```add(value)```
    * *value (object)*: the element to be added
    * *return (void)*
* *Exception*: will raise error if ```distinct``` is activated and ```value``` is already in the binary tree. For more information, take a look: [example ensuring distinct elements](#example-ensuring-distinct-elements).
* *Example*:
```lua
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

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()

for i, value in tree:iterator() do
    -- i holds the element's position in the sort order under forward direction
    -- value holds the element's value
    print(i, value)
end
```

### clear
* *Description*: removes all the elements from the binary tree.
* *Signature*: ```clear()```
    * *return (void)*
* *Example*:
```lua
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
```

### contains
* *Description*: verifies the presence of a given element in the binary tree.
* *Signature*: ```contains(value)```
    * *value (object)*: element to search.
    * *return (boolean)*
* *Example*:
    * First example: contains numbers
    ```lua
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
    ```
    * Second example: contains collaborator by name
    ```lua
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

    print( collaborators:contains({name = 'Bob'}) ) -- prints true

    print( collaborators:contains({name = 'John'}) ) -- prints true

    print( collaborators:contains({name = 'Olivia'}) ) -- prints false
    ```

    ### empty
    * *Description*: verifies the absence of elements in the binary tree.
    * *Signature*: ```empty()```
        * *return (boolean)*
    * *Example*:
    ```lua
    -- loading the module
    local binarytree = require("binarytree")

    -- creating a binary tree instance using the default comparer for numbers
    local tree = binarytree()

    print(tree:empty()) -- prints true

    -- adding numbers to it
    tree:add(3)
    tree:add(1)

    print(tree:empty()) -- prints false
    ```

### find
* *Description*: tries to find the first element (forward direction) in the binary tree matching value.
* *Signature*: ```find(value)```
    * *value (object)*: the element to lookup in the tree
    * *return (boolean, object)*: the first return value indicates whether the element was found or not (true or false), while the second will be the original element added to the collection or nil if it was not there.
* *Example*:
    * First example: finding numbers
    ```lua
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
    ```
    * Second example: finding collaborators by name:
    ```lua
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
    ```
### first
* *Description*: gets the first element (forward direction) in the binary tree.
* *Signature*: ```first()```
    * *return (object)*: the first element.
* *Exception*: will raise error if binary tree is empty.
* *Example*:
```lua
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

print( tree:first() ) -- prints -1
```

### iterator
* *Description*: iterates the binary tree in forward or backward direction.
* *Signature*: ```iterator(backward)```
    * *backward (object - can be nil)*: flag to indicate if the iteration will be in the backward direction.
    * *return (thread)*: a coroutine to iterate the tree.
* *Example*:
```lua
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

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()

for i, value in tree:iterator() do
    -- tree:iterator(false) or tree:iterator(nil)
    -- achieves the same result of calling
    -- tree:iterator()

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
```

### last
* *Description*: gets the last element (forward direction) in the binary tree.
* *Signature*: ```last()```
    * *return (object)*
* *Exception*: will raise error if binary tree is empty.
* *Example*:
```lua
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

print( tree:last() ) -- prints 3
```

### remove
* *Description*: removes an element to the binary tree.
* *Signature*: ```remove(value, all)```
    * *value (object)*: the element to be removed.
    * *all (object - can be nil)*: flag indicating where all the occurrences should be removed. If ```nil``` or ```false``` is passed (the usual form), at most one element will be removed.
    * *return (integer)*: the number of elements removed.
* *Example*:
```lua
-- loading the module
local binarytree = require("binarytree")

-- creating a binary tree instance using the default comparer for numbers
local tree = binarytree()

-- adding numbers to it
tree:add(3)
tree:add(8)
tree:add(2)
tree:add(8)
tree:add(-1)
tree:add(0)
tree:add(2)
tree:add(5)
tree:add(2)

-- removing a single occurrence of 8 from the binary tree
local n1 = tree:remove(8)

print(n1) -- prints 1

-- removing all occurrences of 2 from the binary tree
local n2 = tree:remove(2, true)

print(n2) -- prints 3

-- tries to remove 53 from the tree, but it is not there
local n3 = tree:remove(53)

print(n3) -- prints 0

-- iterating elements in forward direction
print()
print("forward iteration ... ")
print()

for i, value in tree:iterator() do
    -- i holds the element's position in the sort order under forward direction
    -- value holds the element's value
    print(i, value)
end
```

## Unit Tests

In order to run the unit tests, you need the following development dependencies:

* ```busted```
```
luarocks install busted
```

After ```busted``` installation, open a terminal (or command prompt) in the **binarytree** directory and run:
```
lua test.lua
```

## Code Coverage

Since *binarytree* is a tiny library, one primary goal is the achievement of high code coverage running unit tests.

In order to run the code coverage on tests, you need ```busted``` library and also the following development dependencies:

* ```luacov```
```
luarocks install luacov
```
* ```luacov-multiple```
```
luarocks install luacov-multiple
```

After ```luacov``` and ```luacov-multiple``` installation, open a terminal (or command prompt) in the **binarytree** directory and run:

```
lua -lluacov test.lua
```

Once the program finished, navigate to directory ```output > coverage > report``` and open the generated html files on your browser to analyze the code coverage report.

## Change Log

* Version 0.0.2-0: added ```find(value)``` method to the binary tree. See [Find](#find) for more information.
* Version 0.0.1-0: initial release.