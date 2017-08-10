module Players
  class Fann < Base
    attr_reader :fann

    def initialize(fann, sym)
      super(sym)
      @fann = fann
    end

    def next_move(board)
      input = board_data(board)
      move = (fann.run(input).first * 10).round
      raise 'ERROR: invalid move from FANN' unless input_valid?(board, move)
      board.drop_coin(move, sym)
      move
    end

    def to_train_value(board_value)
      case board_value
      when sym
        1
      when '.'
        0
      else
        -1
      end
    end

    def board_data(board)
      board.to_a.flatten.map {|e| to_train_value(e) }
    end
  end
end