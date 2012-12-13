module Steps
  require './strategies'
  include Strategies
  HORIZONTAL = [:up_mesh, :h_cycle, :down_mesh]
  VERTICAL = [:left_mesh, :v_cycle, :right_mesh]
  K = { 1 => :up_mesh, 2 => :h_cycle, 3 => :down_mesh}
  L = { 1 => :left_mesh, 2 => :v_cycle, 3 => :right_mesh}
  CLASTER_CIRCLE = {1 => [1,1], 2 => [1,2], 3 => [1,3], 4 => [2,3], 5 => [3,3], 6 => [3,2], 7 => [3,1], 8 => [2,1]}

  def h_cycle
    if (@from[:j] == 1 && @from[:l] == 1 && !@current_state[:forward]) || (@from[:j] == @step && @from[:l] == 3 && @current_state[:forward])
      # shift to mesh
      p "shift to mesh"
      h_shift_to_other_place
    else
      test = @from.dup
      test[:j] += @current_state[:forward] ? 1 : -1
      test[:j] = @step if test[:j] == 0
      test[:j] = 1 if test[:j] == @step+1
      test[:l] = @current_state[:forward] ? 1 : 3
      if broken?(test)
        h_shift_to_other_place
      else
        @possible_variants[:tried] = []
        @from = test
        put_node(@from)
        true
      end
    end
  end

  def v_cycle
    if (@from[:i] == 1 && @from[:k] == 1 && !@current_state[:forward]) || (@from[:i] == @step && @from[:k] == 3 && @current_state[:forward])
      # shift to mesh
      p "shift to mesh"
      v_shift_to_other_place
    else
      test = @from.dup
      test[:i] += @current_state[:forward] ? 1 : -1
      test[:i] = @step if test[:i] == 0
      test[:i] = 1 if test[:i] == @step+1
      test[:k] = @current_state[:forward] ? 1 : 3
      if broken?(test)
        v_shift_to_other_place
      else
        @possible_variants[:tried] = []
        @from = test
        put_node(@from)
        true
      end
    end
  end

  def v_shift_to_other_place
    @possible_variants[:tried] << @current_state[:type_v]
    test = @from.dup
    if @possible_variants[:tried].size == 3
      return false unless @possible_variants[:forward_way]
      @possible_variants[:tried] = []
      @possible_variants[:forward_way] = false
      @current_state[:forward] = !@current_state[:forward]
      @current_state[:type_v] = L[@from[:l]]
      return true
    end
    @current_state[:type_v] = (VERTICAL - @possible_variants[:tried]).first
    p @current_state
    test[:l] = L.key(@current_state[:type_v])
    if build_in_claster_to(test)
      next_step
    else
      v_shift_to_other_place
    end
  end

  def h_shift_to_other_place
    @possible_variants[:tried] << @current_state[:type_h]
    test = @from.dup
    if @possible_variants[:tried].size == 3
      return false unless @possible_variants[:forward_way]
      @possible_variants[:tried] = []
      @possible_variants[:forward_way] = false
      @current_state[:forward] = !@current_state[:forward]
      @current_state[:type_h] = K[@from[:k]]
      return true
    end
    @current_state[:type_h] = (HORIZONTAL - @possible_variants[:tried]).first
    p @current_state
    test[:k] = K.key(@current_state[:type_h])
    if build_in_claster_to(test)
      next_step
    else
      h_shift_to_other_place
    end
  end

  def up_mesh
    test = @from.dup
    test[:j] += @current_state[:forward] ? 1 : -1
    test[:j] = @step if test[:j] == 0
    test[:j] = 1 if test[:j] == @step+1
    test[:l] = @current_state[:forward] ? 1 : 3
    if broken?(test)
      h_shift_to_other_place
    else
      @possible_variants[:tried] = []
      @from = test
      put_node(@from)
      true
    end
  end

  def down_mesh
    test = @from.dup
    test[:j] += @current_state[:forward] ? 1 : -1
    test[:j] = @step if test[:j] == 0
    test[:j] = 1 if test[:j] == @step+1
    test[:l] = @current_state[:forward] ? 1 : 3
    if broken?(test)
      h_shift_to_other_place
    else
      @possible_variants[:tried] = []
      @from = test
      put_node(@from)
      true
    end
  end

  def right_mesh
    test = @from.dup
    test[:i] += @current_state[:forward] ? 1 : -1
    test[:i] = @step if test[:i] == 0
    test[:i] = 1 if test[:i] == @step+1
    test[:k] = @current_state[:forward] ? 1 : 3
    if broken?(test)
      v_shift_to_other_place
    else
      @possible_variants[:tried] = []
      @from = test
      put_node(@from)
      true
    end
  end

  def left_mesh
    test = @from.dup
    test[:i] += @current_state[:forward] ? 1 : -1
    test[:i] = @step if test[:i] == 0
    test[:i] = 1 if test[:i] == @step+1
    test[:k] = @current_state[:forward] ? 1 : 3
    if broken?(test)
      v_shift_to_other_place
    else
      @possible_variants[:tried] = []
      @from = test
      put_node(@from)
      true
    end
  end

  def build_in_claster(to)
    build_in_claster_to(to)
  end

  def step_in_claster
    current = CLASTER_CIRCLE.key([@from[:k], @from[:l]])
    nex = (current + 1) % 8
    nex = 8 if nex==0
    @from[:k], @from[:l] = CLASTER_CIRCLE[nex]
  end
end
