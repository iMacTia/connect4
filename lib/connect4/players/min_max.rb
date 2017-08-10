module Players
  class MinMax < Base
    BIGINT = 9999999 #Yes, I am lazy
    CUT_DEPTH = 3 #1-3 is quick. 5 is slow (within about a minute), but smart.
    #  Could be used as a difficulty setting

    def initialize(sym)
      super
      @referee = Referee.new
      @win_referee = Referee.new(:winner)
    end

    def actions(board)
      actions = []
      board.width.times do |x|
        unless board.column_full?(x)
          actions << x
        end
      end
      actions
    end

    def evaluate(board)
      @referee.score(board)
    end

    def cut_off?(board, depth)
      if depth >= CUT_DEPTH || board.full? || @win_referee.score(board) != 0
        true
      else
        false
      end
    end

    def next_move(board)
      move = max_value(board, nil, -BIGINT, BIGINT, 0)[1]
      raise 'ERROR: invalid move from MinMax AI' if move == nil
      board.drop_coin(move, sym)
      move
    end

    def min_value(board, pre_action, a, b, depth)
      return [evaluate(board), pre_action] if cut_off?(board, depth)

      m = BIGINT
      actions(board).each do |action|
        new_board = board.clone
        new_board.drop_coin(action, 'X')
        v = max_value(new_board, action, a, b, depth+1)[0]
        if v < m
          m = v
          pre_action = action
        end
        b = m if m < b
      end
      [m, pre_action]
    end

    def max_value(board, pre_action, a, b, depth)
      return [evaluate(board), pre_action] if cut_off?(board, depth)

      m = -BIGINT
      actions(board).each do |action|
        new_board = board.clone
        new_board.drop_coin(action, 'O')
        v = min_value(new_board, action, a, b, depth+1)[0]
        if v > m
          m = v
          pre_action = action
        end
        a = m if m > a
      end
      [m, pre_action]
    end
  end
end
