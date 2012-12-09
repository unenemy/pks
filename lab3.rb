require './matrixer'
require './topologist'
include Topologist

def make_connections
  @matrix = []
  @fibonacci = [0,1]
  if @step > 2
    2.upto(@step-1){|i| @fibonacci[i] = @fibonacci[i-1] + @fibonacci[i-2]} 
  end
  @claster_count = (1..@step).map{|i| (1..i).inject{|p,k| p*=@fibonacci[k-1]} }.inject(:+)
  p @fibonacci
  p @claster_count
  @counter = 0
  @yaruses = []
  @endings = [0]
  1.upto(@step) do |i|
    @endings << (1..i).map{|i| (1..i).inject{|p,k| p*=@fibonacci[k-1]} }.inject(:+)#.inject{|p,k| p*=@fibonacci[k-1]}
  end
  #p @endings
  0.upto(@step-1) do |i|
    @yaruses << (@endings[i]..@endings[i+1]-1).to_a.each_slice(@fibonacci[i] == 0 ? 1 : @fibonacci[i]).to_a
  end
  #p @yaruses
  @proc_count = @claster_count*6
  (@proc_count).times{ @matrix << [] }

  puts "inner connections"
  # in claster connections
  static = [[0,1],[0,2],[0,3],[0,4],[5,1],[5,2],[5,3],[5,4]]
  0.upto @claster_count-1 do |i|
    static.each{|nodes| connect nodes.first + i * 6, nodes.last + i * 6}
  end
  ## out claster connections

  puts "connecting cycles"
  @yaruses.map{|yarus| yarus.flatten}.each do |yarus|
    connect_cycle yarus.map{|node| node*6}
    connect_cycle yarus.map{|node| node*6+5}
  end

  puts "conecting ancestors"
  0.upto(@step-2) do |i|
    @yaruses[i].flatten.each_with_index do |node,j|
      @yaruses[i+1][j].each do |to|
        #puts "CONNECT #{node} and #{to}"
        connect node*6+5, to*6
      end
    end
  end
  puts "connections done"
  @matrix.each{|row| 0.upto(@proc_count-1){|i| row[i] ||= "Ø" } }
  #puts @matrix
end

def output_params
  @matrixer.params
end

print "please input step = "
get_data
make_connections
puts "Processors count = #{@matrix.size}"
@matrixer = Matrixer.new(@matrix)
@matrixer.min_pathes
output_params
puts "input from and to nodes to build path"
while (str = gets) != "exit"
  from, to = str.split(" ")
  puts @matrixer.find_path(from.to_i, to.to_i)
  puts "input from and to nodes to build path"
end

