module Topologist
  def connect(x,y)
    #puts "connecting #{x} to #{y}"
    @matrix[x][y] = @matrix[y][x] = 1
  end

  def connect_cycle(nodes)
    case nodes.size
    when 1
      return
    when 2
      connect nodes.first, nodes.last
    else 
      nodes.each_with_index{|node,i| connect node, nodes[i-1]}
    end
  end

  def connect_mash(mash)
    mash.each { |row| connect_cycle row }
    mash.transpose.each { |row| connect_cycle row }
  end

  def get_data
    @step = gets.to_i
  end
end
