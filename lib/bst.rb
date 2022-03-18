class Node
  #this is a node for a binary tree.
  attr_accessor :left, :right, :val
  @@node_count = 0
  def initialize(val, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
    @@node_count += 1
  end

  def >(obj)
    return self.val > obj.val
  end

  def <(obj)
    return self.val < obj.val
  end

  def ==(obj)
    return self.val == obj.val
  end
end


class BinaryTree 
  #Binary Search Tree,

  def initialize(array)
    @root = build_tree(array)
  end

  def find(val)
    curr = @root
    until(curr.nil?)
      return curr if curr.val == val
      curr.val > val ? curr = curr.left : curr = curr.right
    end
    nil
  end

  def insert(val)
    return "ERROR: Value already in tree" unless self.find(val).nil?

    new_node = Node.new(val) 
    curr = @root
    previous = @root
    until(curr.nil?)
      previous = curr
      curr > new_node ? curr = curr.left : curr = curr.right
    end
      previous > new_node ? previous.left = new_node : previous.right = new_node
  end

  def delete(val)
    return "ERROR: Value not in tree" if self.find(val).nil?
    delete_helper(val)
  end


  
  def level_order(&block)
      if block_given?
        level_order_helper([@root], 0, &block) 
      else
        result_array = []
        level_order_helper([@root], 0) {|node| result_array.push(node.val)}
        result_array
      end
  end

  def height(node)
    height_helper(node, 0)
  end



  def balanced?
    return (height(@root.left) - height(@root.right)).abs < 2 
  end

  def rebalance
    array = level_order
    @root = build_tree(array)
  end


  def pretty_print(node = @root, prefix = '', is_left = true) #print function provided by the odin project
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.val}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end




  private
  def build_tree(array) #creates a balanced binary tree
    array = array.sort.uniq
    start = 0
    fin = array.length - 1
    midpoint = (fin + start)/2
    build_tree_helper(array, start, fin, Node.new(array[midpoint]))
  end

  def build_tree_helper(array, start, fin, curr_node)
    return nil if start > fin


    midpoint = (fin + start)/2
    curr_node.left = build_tree_helper(array, start, midpoint - 1, Node.new(array[(midpoint - 1 + start)/2]))
    curr_node.right = build_tree_helper(array, midpoint + 1, fin, Node.new(array[(fin + midpoint + 1)/2]))
    curr_node
  end

  def delete_helper(val) #skips error check
    #traverse the tree
    curr = @root
    previous = @root
    until(curr.val == val)
      previous = curr
      curr.val > val ? curr = curr.left : curr = curr.right
    end
    if(curr.left.nil? && curr.right.nil?)#shortcut for saying both children are nil
      previous > curr ? previous.left = nil : previous.right = nil
    elsif(curr.left.nil? || curr.right.nil?)#has one child
      if(previous > curr)
        curr.left.nil? ? previous.left = curr.right : previous.left = curr.left
      else
        curr.left.nil? ? previous.right = curr.right : previous.right = curr.left
      end
    else #has two children
       #change it's value to it's leftmost ancestor from it's right subtree, delete that ancestor
      node = curr
      curr = curr.right
      until(curr.left.nil?)
        curr = curr.left
      end
      value = curr.val #saves the leftmost value
      delete_helper(curr.val) #deletes the leftmost value
      node.val = value #puts that value in the node that "got deleted"
    end
  end

  def level_order_helper(array, front_index, &block) 
    #the array acts as a queue
    #base case
    return if array.length <= front_index 
    #handle front of Queue
    return level_order_helper(array, front_index + 1, &block) if array[front_index].nil?

    array.push(array[front_index].left)
    array.push(array[front_index].right)

    yield array[front_index]

    level_order_helper(array, front_index + 1, &block)
  end

  def height_helper(node, count)
    return count - 1 if node.nil?
    left_max = height_helper(node.left, count + 1)
    right_max = height_helper(node.right, count + 1)
    return left_max > right_max ? left_max : right_max
  end

end


# test = BinaryTree.new([1,2,3,5,6,7])


# 100.times {|i| test.insert(rand(-1000..1000))}
# 15.times {|i| test.delete(rand(-1000..1000))}
# p test.balanced?
# test.rebalance
# test.pretty_print
# p test.balanced?
# p test.height(test.find(14))

#result_array = []
#test.level_order{|node| result_array.push(node.val + 1)}
#p result_array
# test = Node.new(3)

# test2 = Node.new(4)

# p test < test2