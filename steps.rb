module Steps
  CLASTER_CIRCLE = {1 => [1,1], 2 => [1,2], 3 => [1,3], 4 => [2,3], 5 => [3,3], 6 => [3,2], 7 => [3,1], 8 => [2,1]}

  def h_cycle
    if in_claster?
      @from[:l] += @current_state[:forward] ? 2 : -2
    else
      if (@from[:j] == 1 && @from[:l] == 1 && !@current_state[:forward]) || (@from[:j] == @step && @from[:l] == 3 && @current_state[:forward])
        # shift to mesh
        p "shift to mesh"
        h_shift_to_mesh
      else
        @from[:j] += @current_state[:forward] ? 1 : -1
        @from[:j] = @step if @from[:j] == 0
        @from[:j] = 1 if @from[:j] == @step+1
        @from[:l] = @current_state[:forward] ? 1 : 3
      end
    end
  end

  def v_cycle
    if in_claster?
      @from[:k] += @current_state[:forward] ? 2 : -2
    else
      if (@from[:i] == 1 && @from[:k] == 1 && !@current_state[:forward]) || (@from[:i] == @step && @from[:k] == 3 && @current_state[:forward])
        # shift to mesh
        p "shift to mesh"
        v_shift_to_mesh
      else
        @from[:i] += @current_state[:forward] ? 1 : -1
        @from[:i] = @step if @from[:i] == 0
        @from[:i] = 1 if @from[:i] == @step+1
        @from[:k] = @current_state[:forward] ? 1 : 3
      end
    end
  end

  def v_shift_to_mesh
    if @from[:j] < @to[:j]
      @from[:l] = 3
    elsif @from[:j] > @to[:j]
      @from[:l] = 1
    elsif @from[:l] != @to[:l]
      @from[:l] = @to[:l]
    else
      @from[:l] = 1
    end
  end

  def h_shift_to_mesh
    if @from[:i] < @to[:i]
      @from[:k] = 3
    elsif @from[:j] > @to[:i]
      @from[:k] = 1
    elsif @from[:k] != @to[:k]
      @from[:k] = @to[:k]
    else
      @from[:k] = 1
    end
  end

  def up_mesh
    if in_claster?
      @from[:l] += @current_state[:forward] ? 1 : -1
    elsif
      @from[:j] += @current_state[:forward] ? 1 : -1
      @from[:j] = @step if @from[:j] == 0
      @from[:j] = 1 if @from[:j] == @step+1
      @from[:l] = @current_state[:forward] ? 1 : 3
    end
  end

  def down_mesh
    if in_claster?
      @from[:l] += @current_state[:forward] ? 1 : -1
    elsif
      @from[:j] += @current_state[:forward] ? 1 : -1
      @from[:j] = @step if @from[:j] == 0
      @from[:j] = 1 if @from[:j] == @step+1
      @from[:l] = @current_state[:forward] ? 1 : 3
    end
  end

  def right_mesh
    if in_claster?
      @from[:k] += @current_state[:forward] ? 1 : -1
    elsif
      @from[:i] += @current_state[:forward] ? 1 : -1
      @from[:i] = @step if @from[:i] == 0
      @from[:i] = 1 if @from[:i] == @step+1
      @from[:k] = @current_state[:forward] ? 1 : 3
    end
  end

  def left_mesh
    if in_claster?
      @from[:k] += @current_state[:forward] ? 1 : -1
    elsif
      @from[:i] += @current_state[:forward] ? 1 : -1
      @from[:i] = @step if @from[:i] == 0
      @from[:i] = 1 if @from[:i] == @step+1
      @from[:k] = @current_state[:forward] ? 1 : 3
    end
  end

  def build_in_claster
    while @from[:k]!=@to[:k] || @from[:l]!=@to[:l]
      step_in_claster
      p @from
    end
  end

  def step_in_claster
    current = CLASTER_CIRCLE.key([@from[:k], @from[:l]])
    nex = (current + 1) % 8
    nex = 8 if nex==0
    @from[:k], @from[:l] = CLASTER_CIRCLE[nex]
  end
end
