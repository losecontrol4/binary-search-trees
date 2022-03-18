#This file is to test the binary search tree class

require_relative 'lib/bst'
seed = rand(0..1000)#change this to a constant to test the same situation
prng1 = Random.new(seed)

test = BinaryTree.new(Array.new(15) { prng1.rand(1..100) })
test.pretty_print
puts("-----------------------")
p test.balanced?
20.times {|i| test.insert(prng1.rand(-1000..1000))}
p test.balanced?
test.pretty_print
puts("-----------------------")
test.rebalance
test.pretty_print
puts("-----------------------")
1000.times {|i| test.delete(prng1.rand(-1000..1000))}
test.rebalance
test.pretty_print
puts("-----------------------")
#multiply all numbers by 3
test.level_order {|node| node.val = node.val * 3}
test.pretty_print