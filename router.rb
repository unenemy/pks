class Router
  require "./steps"
  include Steps
  HORIZONTAL = [:up_mesh, :h_cycle, :down_mesh]
  VERTICAL = [:left_mesh, :v_cycle, :right_mesh]
  K = { 1 => :up_mesh, 2 => :h_cycle, 3 => :down_mesh}
  L = { 1 => :left_mesh, 2 => :v_cycle, 3 => :right_mesh}

  attr_reader :whole_path

  def initialize(step)
    @step = step
    @broken_nodes = []
    @possible_variants = {
      :forward_way => true,
      :tried => []
    }
  end

  def move_horizontal(to_j=nil)
    @possible_variants[:forward_way] = true
    @possible_variants[:tried] = []
    @possible_variants[:i_tried] << @from[:i]
    to_j ||= @to[:j]
    @current_state[:orientation] = :h
    @current_state[:forward] = forward_way?(@from[:j], to_j)
    while @from[:j] != to_j do
      if in_claster?
        test = @from.dup
        test[:l] = @current_state[:forward] ? 3 : 1
        ok = build_in_claster(test)
        while !ok do
          @possible_variants[:tried] << @current_state[:type_h]
          if @possible_variants[:tried].size == 3
            @possible_variants[:tried] = []
            return false unless @possible_variants[:forward_way]
            @possible_variants[:forward_way] = false
            @current_state[:forward] = !@current_state[:forward]
            @current_state[:type_h] = K[@from[:k]]
            break
          end
          @current_state[:type_h] = (HORIZONTAL - @possible_variants[:tried]).first
          test = @from.dup
          test[:l] = @current_state[:forward] ? 3 : 1
          test[:k] = K.key(@current_state[:type_h])
          ok = build_in_claster(test)
        end
      else
        unless next_step
          puts "FAILED HORIZONTAL" 
          return false 
        end
      end
      p @from
      gets
    end
    true
  end

  def move_vertical(to_i=nil)
    @possible_variants[:forward_way] = true
    @possible_variants[:tried] = []
    @possible_variants[:j_tried] << @from[:j]
    to_i ||= @to[:i]
    @current_state[:orientation] = :v
    @current_state[:forward] = forward_way?(@from[:i], to_i)
    while @from[:i] != to_i do
      if in_claster?
        test = @from.dup
        test[:k] = @current_state[:forward] ? 3 : 1
        ok = build_in_claster(test)
        while !ok do
          @possible_variants[:tried] << @current_state[:type_v]
          if @possible_variants[:tried].size == 3
            @possible_variants[:tried] = []
            return false unless @possible_variants[:forward_way]
            @possible_variants[:forward_way] = false
            @current_state[:forward] = !@current_state[:forward]
            @current_state[:type_v] = L[@from[:l]]
            break
          end
          @current_state[:type_v] = (VERTICAL - @possible_variants[:tried]).first
          test = @from.dup
          test[:k] = @current_state[:forward] ? 3 : 1
          test[:l] = L.key(@current_state[:type_v])
          ok = build_in_claster(test)
        end
      else
        unless next_step
          puts "FAILED VERTICAL" 
          return false 
        end
      end
      p @from
      gets
    end
    true
  end

  def one_to_one(from, to)
    @possible_variants = {
      :forward_way => true,
      :tried => [],
      :i_tried => [],
      :j_tried => []
    }
    @whole_path = [from.map(&:last).join]
    @from = from
    @to = to
    @current_state = start_state(from, to)
    p @current_state
    moved_horizontal = @from[:j] == @to[:j]
    ok = true
    while !moved_horizontal
      puts "moving horizontal"
      p @possible_variants
      moved_horizontal = move_horizontal if ok
      break if move_horizontal
      to_i = ((1..@step).to_a - @possible_variants[:i_tried]).first
      ok = move_vertical(to_i)
      @possible_variants[:i_tried] << to_i unless ok
      if @possible_variants[:i_tried].size == @step
        puts "FAILED TO FIND PATH ANY HORIZONTAL"
        return
      end
    end

    puts "Horizontal moved"

    moved_vertical = @from[:i] == @to[:i]
    ok = true
    while !moved_vertical
      puts "moving vertical"
      p @possible_variants
      moved_vertical = move_vertical if ok
      break if moved_vertical
      to_j = ((1..@step).to_a - @possible_variants[:j_tried]).first
      ok = move_horizontal(to_j)
      @possible_variants[:j_tried] << to_j unless ok
      if @possible_variants[:j_tried].size == @step
        puts "FAILED TO FIND PATH ANY VERTICAL"
        return
      end
    end

    puts "Vertical moved"

    if @from[:j] != @to[:j]
      puts "Transfered on right row, try to go to the right column"
      unless move_horizontal
        puts "FAILED TO FIND PATH HORIZONTAL, sorry"
        return
      end
    end

    puts "before claster search"
    p @from
    p @to
    puts "FAILED TO FIND PATH in claster" unless build_in_claster(@to)
  end

  def next_step
    self.send(@current_state["type_#{@current_state[:orientation]}".to_sym])
  end

  def start_state(from, to)
    {
      :forward => forward_way?(from[:i],to[:i]),
      :orientation => :v,
      :type_h => K[from[:k]],
      :type_v => L[from[:l]]
    }
  end

  def refresh_current_state
    @current_state[:type_h] = K[@from[:k]]
    @current_state[:type_v] = L[@from[:l]]
  end

  def in_claster?
    !((@current_state[:orientation] == :v && @current_state[:forward] && @from[:k] == 3)||
    (@current_state[:orientation] == :v && !@current_state[:forward] && @from[:k] == 1)||
    (@current_state[:orientation] == :h && @current_state[:forward] && @from[:l] == 3)||
    (@current_state[:orientation] == :h && !@current_state[:forward] && @from[:l] == 1))
  end

  def forward_way?(from, to)
    reverse = false
    from, to, reverse = to, from, true if from > to
    ((to - from) < (from + @step - to)) ^ reverse
  end

  def break!(to_break)
    @broken_nodes << to_break
    p @broken_nodes
  end

  def broken?(node)
    puts "!! Tryed to go to --> #{node.map(&:last).join} but it's BROKEN!" if @broken_nodes.include?(node.map(&:last).join)
    @whole_path << "try to broken #{node.map(&:last).join}" if @broken_nodes.include?(node.map(&:last).join)
    @broken_nodes.include?(node.map(&:last).join)
  end

  def heal!(node)
    @broken_nodes -= [node]
    p @broken_nodes
  end

  def put_node(node)
    @whole_path << node.map(&:last).join
    puts "go to --> #{node.map{|k,v| v}.join}"
  end
end
