class Matrixer
  def initialize(matrix)
    @matrix = matrix
    @normal_matrix = @matrix.map{|row| row.map{|node| node==1?1:0}}
    #show_matrix(@matrix)
  end

  def stepen
    @s = @normal_matrix.map{|row| row.inject(:+)}.max
  end

  def min_pathes
    puts "please wait minimum pathes building for matrix #{@matrix.size}x#{@matrix.size}"
    floyder = Floyd.new(@matrix.dup)
    floyder.traitement
    @pathes = floyder.min_pathes
    @routes = floyder.routes
    #show_matrix(@pathes)
    puts "building min pathes done"
  end

  def show_matrix(matrix)
    puts "###############"
    puts "Matrix:"
    matrix.each_index do |i|
        puts matrix[i].join(" | ")
    end
  end

  def find_path(from, to)
    puts "path from #{from} to #{to}"
    path = [to]
    while @routes[from][to] != from
      path.unshift @routes[from][to]
      to = @routes[from][to]
    end
    path.unshift from
    path.join("-->")
  end

  def params
    @d = longest_path
    puts "D  = #@d"
    @ds = @pathes.inject(:+).inject(:+).to_f / (@pathes.size*(@pathes.size-1))
    puts "Ds = #@ds"
    stepen
    puts "S  = #@s"
    puts "C  = #{@s*@d*@matrix.size}"
    puts "T  = #{2*@ds/@s}"
    @pathes.each_with_index do |row,i|
        row.each_with_index do |node,j|
            @i,@j=i,j if node == @d
        end
    end
    puts "Maximum path is from #@i to #@j"
    puts find_path @i, @j
    # d ds s c t
    [@d,@ds,@s,@s*@d*@matrix.size,2*@ds/@s]
  end

  def longest_path
    @pathes.map{|row| row.max}.max
  end

  class Floyd
    def initialize(graph = Array.new, pre = Array.new)
      @graph = graph
      @pre = pre
      graph.each_index do |i|
        pre[i] = Array.new
        graph.each_index do |j|
          pre[i][j] = i+1
        end
      end
    end

    def traitement
      @graph.each_index do |k|
        @graph.each_index do |i|
          @graph.each_index do |j|
            if (@graph[i][j] == "Ø") && (@graph[i][k] != "Ø" && @graph[k][j] != "Ø")
              @graph[i][j] = @graph[i][k]+@graph[k][j]
              @pre[i][j] = @pre[k][j]
            elsif (@graph[i][k] != "Ø" && @graph[k][j] != "Ø") && (@graph[i][j] > @graph[i][k]+@graph[k][j])
              @graph[i][j] = @graph[i][k]+@graph[k][j]
              @pre[i][j] = @pre[k][j]
            end
          end
        end
        if $verbose == 1
          puts "\nk = #{k+1}"
          output
        end
      end
    end

    def output
      @graph.each_index do |i|
          puts @graph[i].join(" | ")
      end
      @pre.each_index do |i|
          puts @pre[i].map{|x| x-1}.join(" | ")
      end
    end

    def min_pathes
      @graph.each_with_index{|row,i| row[i]=0}
      @graph
    end

    def routes
      @pre.map{|row| row.map{|node| node-1}}
    end
  end
end
