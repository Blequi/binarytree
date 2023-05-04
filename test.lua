require("busted.runner")()

-- helper functions
local permgen = nil
permgen = function(a, n)
    if (n == 0) then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[n], a[i] = a[i], a[n]

            permgen(a, n - 1)

            a[n], a[i] = a[i], a[n]
        end
    end
end

local function permutations(a)
    return coroutine.wrap(function() permgen(a, #a) end)
end

local function assert_table_and_tree_are_forward_equals(tab, tree)
    assert.are.equals(#tab, tree.count)

    for i, v in tree:iterator() do
        assert.are.equals(tab[i], v)
    end

    if (#tab > 0) then
        assert.are.equals(tab[1], tree:first())
        assert.are.equals(tab[#tab], tree:last())
    end
end

local function assert_table_and_tree_are_backward_equals(tab, tree)
    assert.are.equals(#tab, tree.count)

    for i, v in tree:iterator(true) do
        assert.are.equals(tab[#tab - i + 1], v)
    end

    if (#tab > 0) then
        assert.are.equals(tab[1], tree:first())
        assert.are.equals(tab[#tab], tree:last())
    end
end

-- end of helper functions

local binarytree = require("binarytree")

describe("module loading", function()
    it("should not be nil", function()
        assert.are_not.equals(nil, binarytree)
    end)

    it("should return a function", function()
        assert.are.equals('function', type(binarytree))
    end)
end)

describe("binary tree initialization", function()
    it("should not be nil with a nil comparer", function()
        assert.are_not.equals(nil, binarytree())    
    end)

    it("should not be nil with a non-nil comparer and nil distinct", function()
        assert.are_not.equals(nil, binarytree(function(a, b) return 0 end))    
    end)

    it("should not be nil with a non-nil comparer and true distinct", function()
        assert.are_not.equals(nil, binarytree(function(a, b) return 0 end, true))    
    end)

    it("should not be nil with a non-nil comparer and false distinct", function()
        assert.are_not.equals(nil, binarytree(function(a, b) return 0 end, false))    
    end)

    it("should start with count as 0 provided a nil comparer", function()
        assert.are.equals(0, binarytree().count)    
    end)

    it("should start with count as 0 provided a non-nil comparer and nil distinct", function()
        assert.are.equals(0, binarytree(function(a, b) return 0 end).count)
    end)

    it("should start with count as 0 provided a non-nil comparer and true distinct", function()
        assert.are.equals(0, binarytree(function(a, b) return 0 end, true).count)
    end)

    it("should start with count as 0 provided a non-nil comparer and false distinct", function()
        assert.are.equals(0, binarytree(function(a, b) return 0 end, false).count)
    end)

    it("should start empty provided a nil comparer", function()
        assert.True(binarytree():empty())    
    end)

    it("should start empty provided a non-nil comparer and nil distinct", function()
        assert.True(binarytree(function(a, b) return 0 end):empty())
    end)

    it("should start empty provided a non-nil comparer and true distinct", function()
        assert.True(binarytree(function(a, b) return 0 end, true):empty())
    end)

    it("should start empty provided a non-nil comparer and false distinct", function()
        assert.True(binarytree(function(a, b) return 0 end, false):empty())
    end)

    it("should throw error if comparer is a number and distinct is nil", function()
        assert.False(pcall(function() binarytree(0) end))
        assert.False(pcall(function() binarytree(1) end))
        assert.False(pcall(function() binarytree(0.4) end))
        assert.False(pcall(function() binarytree(-0.4) end))
    end)

    it("should throw error if comparer is a string and distinct is nil", function()
        assert.False(pcall(function() binarytree('0') end))
        assert.False(pcall(function() binarytree('1') end))
        assert.False(pcall(function() binarytree('') end))
        assert.False(pcall(function() binarytree('-0.4') end))
    end)

    it("should throw error if comparer is a string and distinct is nil", function()
        assert.False(pcall(function() binarytree('0') end))
        assert.False(pcall(function() binarytree('1') end))
        assert.False(pcall(function() binarytree('') end))
        assert.False(pcall(function() binarytree('-0.4') end))
    end)
end)

describe("binary tree's comparer property", function()
    it("should be read-only if comparer is nil", function()
        assert.False(pcall(function() binarytree().comparer = function(a, b) return 1 end end))
    end)

    it("should be read-only if comparer is not-nil", function()
        assert.False(pcall(function() binarytree(function(a, b) return 1 end).comparer = nil end))
    end)
end)

describe("binary tree's count property", function()
    it("should be read-only if comparer is nil", function()
        assert.False(pcall(function() binarytree().count = function(a, b) return 1 end end))
    end)

    it("should be read-only if comparer is not-nil", function()
        assert.False(pcall(function() binarytree(function(a, b) return 1 end).count = nil end))
    end)
end)

describe("binary tree's arbitrary properties", function()
    it("should be read-only if comparer is nil", function()
        assert.False(pcall(function() binarytree()['word'] = 1 end))
        assert.False(pcall(function() binarytree()[2] = 1 end))
        assert.False(pcall(function() binarytree()[nil] = 1 end))
        assert.False(pcall(function() binarytree()[false] = 1 end))
        assert.False(pcall(function() binarytree()[true] = 1 end))
        assert.False(pcall(function() binarytree()[function() end] = 1 end))
        assert.False(pcall(function() binarytree()[{}] = 1 end))
        assert.False(pcall(function() binarytree()[coroutine.wrap(function() end)] = 1 end))
    end)

    it("should be read-only if comparer is not-nil", function()
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)['word'] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[2] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[nil] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[false] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[true] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[function() end] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[{}] = 1 end))
        assert.False(pcall(function() binarytree(function(a, b) return 1 end)[coroutine.wrap(function() end)] = 1 end))
    end)
end)

describe("binary tree's first method", function()
    it("should throw error if tree is empty", function()
        assert.False(pcall(function() binarytree():first() end))
    end)

    it("should throw error if tree is empty after deleting element", function()
        local bt = binarytree()
        local v = -25
        bt:add(v)
        bt:remove(v)

        assert.False(pcall(function()
            bt:first()
        end))
    end)

    it("should throw error if tree is empty", function()
        assert.False(pcall(function() binarytree(function(a, b) return 1 end):first() end))
    end)

    it("should throw error if tree is empty after deleting element", function()
        local bt = binarytree(function(a, b) return a - b end)
        local v = -25
        bt:add(v)
        bt:remove(v)

        assert.False(pcall(function()
            bt:first()
        end))
    end)
end)

describe("binary tree's last method", function()
    it("should throw error if tree is empty", function()
        assert.False(pcall(function() binarytree():last() end))
    end)

    it("should throw error if tree is empty after deleting element", function()
        local bt = binarytree()
        local v = -25
        bt:add(v)
        bt:remove(v)

        assert.False(pcall(function()
            bt:last()
        end))
    end)

    it("should throw error if tree is empty", function()
        assert.False(pcall(function() binarytree(function(a, b) return 1 end):last() end))
    end)

    it("should throw error if tree is empty after deleting element", function()
        local bt = binarytree(function(a, b) return a - b end)
        local v = -25
        bt:add(v)
        bt:remove(v)

        assert.False(pcall(function()
            bt:last()
        end))
    end)
end)

describe("binary tree with a single element", function()
    it("should match for numbers in forward direction", function()
        local values = {1, -0.5, -1, 0}
        
        for i, v in ipairs(values) do
            local test_collection = {v}
            local tree = binarytree()
            tree:add(v)
            assert_table_and_tree_are_forward_equals(test_collection, tree)
        end
    end)

    it("should match for numbers in backward direction", function()
        local values = {1, -0.5, -1, 0}
        
        for i, v in ipairs(values) do
            local test_collection = {v}
            local tree = binarytree()
            tree:add(v)
            assert_table_and_tree_are_backward_equals(test_collection, tree)
        end
    end)
end)

describe("clear method", function()
    it("should not iterate forward for all trees starting with up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                tree:clear()
    
                assert.are.equals(0, tree.count)
                assert.True(tree:empty())
    
                for j, v in tree:iterator() do
                    assert.True(false)
                end
            end
        end
    end)

    it("should not iterate backward for all trees starting with up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                tree:clear()
    
                assert.are.equals(0, tree.count)
                assert.True(tree:empty())
    
                for j, v in tree:iterator(true) do
                    assert.True(false)
                end
            end
        end
    end)
end)

describe("contains method", function()
    it("should return true for each element of a collection for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end
                
                for k, v in ipairs(sorted_collection) do
                    assert.True(tree:contains(v))
                end
            end
        end
    end)

    it("should return false if the target element is greater than the max element, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end
                
                assert.False(tree:contains(5))
            end
        end
    end)

    it("should return false if the target element is smaller than the min element, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end
                
                assert.False(tree:contains(-1))
            end
        end
    end)
end)

describe("remove method with nil 'all' parameter", function()
    it("should return 1 removing each element, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                for m, tc_value in ipairs(work_collection) do
                    local tree = binarytree()
                    for k, v in ipairs(test_collection) do
                        tree:add(v)
                    end
                    
                    for n, v in ipairs(work_collection) do
                        assert.are.equals(1, tree:remove(v))
                    end
                end
            end
        end
    end)
end)

describe("add method", function()
    it("should throw error if distinct is true and an element already in the collection is tried, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                for ti, tv in ipairs(sorted_collection) do
                    local tree = binarytree(nil, true)
                    for k, v in ipairs(test_collection) do
                        tree:add(v)
                    end

                    assert.False(pcall(function() tree:add(tv) end))
                end
            end
        end
    end)
end)

describe("remove method with true 'all' parameter", function()
    it("should return 0 if element was not in the collection, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                assert.are.equals(0, tree:remove(-1, true))
                assert.are.equals(0, tree:remove(5, true))

                assert_table_and_tree_are_forward_equals(sorted_collection, tree)
            end
        end
    end)

    it("should sort all permutations up to 5 elements in forward direction with one repeated element", function()
        
        local sorted_collection_list = {
            {
                {1, 1}
            },
            --
            {
                {1, 1, 2},
                {1, 2, 2}
            },
            --
            {
                {1, 1, 2, 3},
                {1, 2, 2, 3},
                {1, 2, 3, 3}
            },
            --
            {
                {1, 1, 2, 3, 4},
                {1, 2, 2, 3, 4},
                {1, 2, 3, 3, 4},
                {1, 2, 3, 4, 4}
            }
        }

        for i, sorted_collection_diag in ipairs(sorted_collection_list) do
            for l, sorted_collection in ipairs(sorted_collection_diag) do
                local work_collection = {}
                for j, v in ipairs(sorted_collection) do
                    table.insert(work_collection, v)
                end
    
                for test_collection in permutations(work_collection) do
                    local tree = binarytree()
                    for k, v in ipairs(test_collection) do
                        tree:add(v)
                    end

                    assert.are.equals(2, tree:remove(l, true))
                end
            end
        end
    end)
end)

describe("binary tree construction", function()
    it("should sort all permutations up to 4 elements in forward direction", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                assert_table_and_tree_are_forward_equals(sorted_collection, tree)
            end
        end
    end)

    it("should sort all permutations up to 4 elements in backward direction", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                assert_table_and_tree_are_backward_equals(sorted_collection, tree)
            end
        end
    end)

    it("should sort all permutations up to 5 elements in forward direction with one repeated element", function()
        
        local sorted_collection_list = {
            {1},
            {1, 1},
            --
            {1, 2},
            {1, 1, 2},
            {1, 2, 2},
            --
            {1, 2, 3},
            {1, 1, 2, 3},
            {1, 2, 2, 3},
            {1, 2, 3, 3},
            --
            {1, 2, 3, 4},
            {1, 1, 2, 3, 4},
            {1, 2, 2, 3, 4},
            {1, 2, 3, 3, 4},
            {1, 2, 3, 4, 4}
        }

        for i, sorted_collection in ipairs(sorted_collection_list) do
            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                assert_table_and_tree_are_forward_equals(sorted_collection, tree)
            end
        end
    end)

    it("should sort all permutations up to 5 elements in backward direction with one repeated element", function()
        
        local sorted_collection_list = {
            {1},
            {1, 1},
            --
            {1, 2},
            {1, 1, 2},
            {1, 2, 2},
            --
            {1, 2, 3},
            {1, 1, 2, 3},
            {1, 2, 2, 3},
            {1, 2, 3, 3},
            --
            {1, 2, 3, 4},
            {1, 1, 2, 3, 4},
            {1, 2, 2, 3, 4},
            {1, 2, 3, 3, 4},
            {1, 2, 3, 4, 4}
        }

        for i, sorted_collection in ipairs(sorted_collection_list) do
            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end

                assert_table_and_tree_are_backward_equals(sorted_collection, tree)
            end
        end
    end)

    it("should work with strings", function()
        local values = {"a", "c", "b", "f", "g", "e", "d", "c"}
        local sorted_values = {}

        local tree = binarytree()

        for i, v in ipairs(values) do
            table.insert(sorted_values, v)
            tree:add(v)
        end
        
        table.sort(sorted_values)

        assert_table_and_tree_are_forward_equals(sorted_values, tree)
        assert_table_and_tree_are_backward_equals(sorted_values, tree)
    end)
end)

describe("find method", function()
    it("should return false for elements inside a newly created tree", function()
        local tree = binarytree()

        local values = {0, -1, 1, '-1', '1', function() end, {}, false, true, nil}

        for i, v in ipairs(values) do
            local found, element = tree:find(v)
    
            assert.False(found)
            assert.are.equals(nil, element)
        end
    end)

    
    it("should return true for elements that belong to collection, for all permutations up to 4 elements", function()
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end
                
                for j, v in ipairs(test_collection) do
                    local found, element = tree:find(v)

                    assert.True(found)
                    assert.are.equals(v, element)
                end
            end
        end
    end)

    
    it("should return false for elements that do not belong to collection, for all permutations up to 4 elements", function()
        local lookup_elements = {-1, 10, 3.2}
        
        local sorted_collection = {}
        for i = 1, 4 do
            table.insert(sorted_collection, i)

            local work_collection = {}
            for j, v in ipairs(sorted_collection) do
                table.insert(work_collection, v)
            end

            for test_collection in permutations(work_collection) do
                local tree = binarytree()
                for k, v in ipairs(test_collection) do
                    tree:add(v)
                end
                
                for j, v in ipairs(lookup_elements) do
                    local found, element = tree:find(v)

                    assert.False(found)
                    assert.are.equals(nil, element)
                end
            end
        end
    end)

    it("should return true for objects found by key 'a'", function()
        local comparer = function(a, b) return a.a - b.a end

        local tree = binarytree(comparer)

        local one = {a = 1, b = 's'}
        local five = {a = 5, b = 't'}
        local minus_one = {a = -1, b = 'u'}

        tree:add(one)
        tree:add(five)
        tree:add(minus_one)

        local found, element = tree:find({a = 1})

        assert.True(found)
        assert.are.equals(one.a, element.a)
        assert.are.equals(one.b, element.b)
        
        found, element = tree:find({a = 5})

        assert.True(found)
        assert.are.equals(five.a, element.a)
        assert.are.equals(five.b, element.b)

        found, element = tree:find({a = -1})

        assert.True(found)
        assert.are.equals(minus_one.a, element.a)
        assert.are.equals(minus_one.b, element.b)
    end)


    it("should return false for objects not found by key 'a'", function()
        local comparer = function(a, b) return a.a - b.a end

        local tree = binarytree(comparer)

        local one = {a = 1, b = 's'}
        local five = {a = 5, b = 't'}
        local minus_one = {a = -1, b = 'u'}

        tree:add(one)
        tree:add(five)
        tree:add(minus_one)

        local found, element = tree:find({a = 4})

        assert.False(found)
        assert.are.equals(nil, element)

        found, element = tree:find({a = 8})

        assert.False(found)
        assert.are.equals(nil, element)
        
        found, element = tree:find({a = 3.2})

        assert.False(found)
        assert.are.equals(nil, element)
    end)
end)