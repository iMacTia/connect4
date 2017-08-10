require 'ruby-fann'
require_relative '../lib/connect4'

### YOU
player_x = Players::Human.new('X')

### Play against FANN
fann_path = File.path('/Users/mattiagiuffrida/Development/RubymineProjects/fann/connect4/networks/level-3.net')
fann = RubyFann::Standard.new(filename: fann_path)
player_o = Players::Fann.new(fann, 'O')

### Play against MinMax AI
# player_o = Players::MinMax.new('O') # MinMax AI can only play O for now

board = Board.build(7, 6)
referee = Referee.new(:winner)

# Clear some space
10.times { puts "\n" }

# Game loop
[player_x, player_o].cycle do |player|
  player.next_move(board)

  winner = referee.score(board)
  full = board.full?

  if full || winner != 0
    board.output(erase_before: true)

    case winner
    when 0
      puts 'DRAW!'
    when 1
      puts 'O WINS!'
    when -1
      puts 'X WINS!'
    end

    break
  end
end
