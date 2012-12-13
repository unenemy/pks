module Strategies
  CLASTER_CIRCLE = {1 => [1,1], 2 => [1,2], 3 => [1,3], 4 => [2,3], 5 => [3,3], 6 => [3,2], 7 => [3,1], 8 => [2,1]}

  def strategy_from_mp
    {
      :mpf => [[:mpf]],
      :cprc => [[:cprc]],
      :cplc => [[:cplc]],
      :mpl => [[:mpl]],
      :mpr => [[:mpr]],
      :cprf => [[:mpr, :cprf],[:cplc, :cprf],[:mpf,:cprf]],
      :cplf => [[:mpl, :cplf],[:cprc, :cplf],[:mpf,:cplf]]
    }
  end
  
  def strategy_from_cp
    {
      :mprc => [[:mprc]],
      :mplc => [[:mplc]],
      :cpf => [[:cpf]],
      :cpr => [[:mprc, :cpr],[:cpf, :mprf, :cpr],[:mplc,:mprf,:cpr],[:mplc, :cpl, :cpr],[:cpf, :mplf, :cpl, :cpr]],
      :cpl => [[:mplc, :cpl],[:cpf, :mplf, :cpl],[:mprc,:mplf,:cpl],[:mprc, :cpr, :cpl],[:cpf, :mprf, :cpr, :cpl]],
      :mprf => [[:mprc, :mprf],[:cpf, :mprf],[:mplc, :mprf]],
      :mplf => [[:mplc, :mplf],[:cpf, :mplf],[:mprc, :mplf]]
    }
  end

  def build_in_claster_to(to)
    side = (@from[:k]%2 == 1 && @from[:l]%2 == 1) ? :cp : :mp
    if side == :cp
      build_from_cp_to(to)
    else
      build_from_mp_to(to)
    end
  end

  def build_from_cp_to(to)
    puts "BUILDING from CP"
    current = CLASTER_CIRCLE.key([@from[:k], @from[:l]])
    values = {
      :mplc => CLASTER_CIRCLE[((current+1)%8)==0 ? 8 : (current+1)%8],
      :cpl  => CLASTER_CIRCLE[((current+2)%8)==0 ? 8 : (current+2)%8],
      :mplf => CLASTER_CIRCLE[((current+3)%8)==0 ? 8 : (current+3)%8],
      :cpf  => CLASTER_CIRCLE[((current+4)%8)==0 ? 8 : (current+4)%8],
      :mprf => CLASTER_CIRCLE[((current+5)%8)==0 ? 8 : (current+5)%8],
      :cpr  => CLASTER_CIRCLE[((current+6)%8)==0 ? 8 : (current+6)%8],
      :mprc => CLASTER_CIRCLE[((current+7)%8)==0 ? 8 : (current+7)%8]
    }
    puts "VALUES"
    p values
    tosym = values.key([to[:k],to[:l]])
    p tosym
    strategies = strategy_from_cp[tosym].map{|x| {:strategy => x, :available => true}}
    found = false
    p strategies
    while !strategies.find{|x| x[:available]}.nil? && !found
      puts "we are in while"
      gets
      path = []
      strategy = strategies.find{|x| x[:available]}
      strategy[:strategy].each do |node|
        puts "Going to #{node}"
        gets
        test = @from.dup
        test[:k], test[:l] = values[node]
        if broken?(test)
          #wayback
          path.reverse.each do |back_node|
            gets
            @from[:k], @from[:l] = back_node
            p @from
          end
          path = []
          #mark broken pathes
          strategies.each{|x| x[:available] = false if x[:strategy].include?(node)}
          break
        else
          path << [@from[:k],@from[:l]]
          @from[:k], @from[:l] = values[node]
        end
        p @from
      end
      found = true if @from[:k]==to[:k] && @from[:l] == to[:l]
    end
    found
  end

  def build_from_mp_to(to)
    puts "BUILDING from MP"
    current = CLASTER_CIRCLE.key([@from[:k], @from[:l]])
    values = {
      :cplc => CLASTER_CIRCLE[((current+1)%8)==0 ? 8 : (current+1)%8],
      :mpl  => CLASTER_CIRCLE[((current+2)%8)==0 ? 8 : (current+2)%8],
      :cplf => CLASTER_CIRCLE[((current+3)%8)==0 ? 8 : (current+3)%8],
      :mpf  => CLASTER_CIRCLE[((current+4)%8)==0 ? 8 : (current+4)%8],
      :cprf => CLASTER_CIRCLE[((current+5)%8)==0 ? 8 : (current+5)%8],
      :mpr  => CLASTER_CIRCLE[((current+6)%8)==0 ? 8 : (current+6)%8],
      :cprc => CLASTER_CIRCLE[((current+7)%8)==0 ? 8 : (current+7)%8]
    }
    puts "VALUES"
    p values
    tosym = values.key([to[:k],to[:l]])
    p tosym
    strategies = strategy_from_mp[tosym].map{|x| {:strategy => x, :available => true}}
    found = false
    p strategies
    while !strategies.find{|x| x[:available]}.nil? && !found
      puts "we are in while"
      gets
      path = []
      strategy = strategies.find{|x| x[:available]}
      strategy[:strategy].each do |node|
        puts "Going to #{node}"
        gets
        test = @from.dup
        test[:k], test[:l] = values[node]
        if broken?(test)
          #wayback
          path.reverse.each do |back_node|
            gets
            @from[:k], @from[:l] = back_node
            p @from
          end
          path = []
          #mark broken pathes
          strategies.each{|x| x[:available] = false if x[:strategy].include?(node)}
          break
        else
          path << [@from[:k],@from[:l]]
          @from[:k], @from[:l] = values[node]
        end
        p @from
      end
      found = true if @from[:k]==to[:k] && @from[:l] == to[:l]
    end
    found
  end

end
