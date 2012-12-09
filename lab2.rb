require './matrixer'
require './topologist'
include Topologist

def make_connections
  @matrix = []
  @proc_count = @step*@step*8
  @claster_count = @step**2
  (@proc_count).times{ @matrix << [] }

  puts "inner connections"
  # in claster connections
  static_4_one = [[0,1],[0,3],[1,2],[2,4],[3,5],[4,7],[5,6],[6,7]]
  static = [[1,3],[1,4],[3,6],[4,6]]
  0.upto @claster_count-1 do |i|
    static.each{|nodes| connect nodes.first + i * 8, nodes.last + i * 8}
  end
  # out claster connections

  clasters = (0..@claster_count-1).each_slice(@step).to_a
  rev_clasters = clasters.transpose
  puts "outer mesh connecting"
  if @step > 1
    clasters.map{|row| row.map{|node| [node*8+0, node*8+1, node*8+2]}.inject{|sum,row| sum+=row }}.each {|row| connect_cycle row}
    clasters.map{|row| row.map{|node| [node*8+5, node*8+6, node*8+7]}.inject{|sum,row| sum+=row }}.each {|row| connect_cycle row}
    rev_clasters.map{|row| row.map{|node| [node*8+0, node*8+3, node*8+5]}.inject{|sum,row| sum+=row }}.each {|row| connect_cycle row}
    rev_clasters.map{|row| row.map{|node| [node*8+2, node*8+4, node*8+7]}.inject{|sum,row| sum+=row }}.each {|row| connect_cycle row}
  else
    static_4_one.each{|nodes| connect nodes.first, nodes.last}
  end

  puts "big cycles conecting"

  connect_cycle rev_clasters.inject{|sum,row| sum+=row}.map{|node| [node*8+1,node*8+6]}.inject{|sum,row| sum+=row}

  connect_cycle clasters.inject{|sum,row| sum+=row}.map{|node| [node*8+3,node*8+4]}.inject{|sum,row| sum+=row}

  puts "connections done"
  @matrix.each{|row| 0.upto(@proc_count-1){|i| row[i] ||= "Ø" } }
  #puts @matrix
end

#def output_params
  #@matrixer.params
#end

#print "please input step = "
#get_data
#make_connections
#puts "Processors count = #{@matrix.size}"
#@matrixer = Matrixer.new(@matrix)
#@matrixer.min_pathes
#output_params
#puts "input from and to nodes to build path"
#while (str = gets) != "exit"
  #from, to = str.split(" ")
  #puts @matrixer.find_path(from.to_i, to.to_i)
  #puts "input from and to nodes to build path"
#end

def output_params
  d, ds, s, c , t = @matrixer.params
  @resd << d
  @resds << ds
  @ress << s
  @resc << c
  @rest << t
end

@resd = []
@resds = []
@resp = []
@resc = []
@rest = []
@ress = []

1.upto(6) do |step|
@step = step
make_connections
puts "Processors count = #{@matrix.size}"
@resp << @matrix.size
@matrixer = Matrixer.new(@matrix)
@matrixer.min_pathes
output_params
end

puts "D"
p @resd
puts "Ds"
p @resds
puts "S"
p @ress
puts "C"
p @resc
puts "T"
p @rest
puts "P"
p @resp
