module Players
  class Human < Base
    def next_move(board)
      board.output(erase_before: true)
      move = nil
      loop do
        move = (gets.chomp).to_i
        break if input_valid?(board, move)
      end
      board.drop_coin(move, sym)
      move
    end
  end
end