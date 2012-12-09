class Router
  require "./steps"
  include Steps
  K = { 1 => :up_mesh, 2 => :h_cycle, 3 => :down_mesh}
  L = { 1 => :left_mesh, 2 => :v_cycle, 3 => :right_mesh}

  def initialize(step)
    @step = step
  end

  def one_to_one(from, to)
    @from = from
    @to = to
    @current_state = start_state(from, to)
    p @current_state
    while @from[:i] != @to[:i]
      next_step
      refresh_current_state
      p @from
      gets
    end
    
    @current_state[:orientation] = :h
    @current_state[:forward] = forward_way?(from[:j], to[:j])

    while @from[:j] != @to[:j]
      next_step
      refresh_current_state
      p @from
      gets
    end

    build_in_claster
  end

  def next_step
    self.send(@current_state["type_#{@current_state[:orientation]}".to_sym])
    p in_claster?
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
end
