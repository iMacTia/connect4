module Players
  class Base
    attr_reader :sym

    def initialize(sym)
      @sym = sym
    end

    def input_valid?(board, move)
      move >= 0 and move <= 6 and !board.column_full?(move)
    end
  end
end