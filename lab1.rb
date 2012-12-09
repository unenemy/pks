require './matrixer'
require './topologist'
include Topologist

def make_connections
  @matrix = []
  (@step*13).times{ @matrix << [] }
  # in claster connections
  mash = [[4,5,6],[7,8,9],[10,11,12]]
  static = [[0,4],[0,5],[0,6],[1,6],[1,9],[1,12],[2,10],[2,11],[2,12],[3,4],[3,7],[3,10]]
  0.upto @step-1 do |i|
    connect_mash mash.map{|row| row.map{|node| node + i*13}}
    static.each{|nodes| connect nodes.first + i * 13, nodes.last + i * 13}
  end
  # out claster connections
  (0..@step-1).map{|x| x*13}.map{|x| [x,x+1,x+2,x+3]}.transpose.each{|row| connect_cycle row}
  puts "connections done"
  @matrix.each{|row| 0.upto(@step*13-1){|i| row[i] ||= "Ø" } }
  #puts @matrix
end

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

1.upto(20) do |step|
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
