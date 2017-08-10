require 'ruby-fann'
require_relative '../lib/connect4'

MSE = 0.001

fann_path = File.path('/Users/mattiagiuffrida/Development/RubymineProjects/fann/connect4/networks/level-3.net')
fann = RubyFann::Standard.new(filename: fann_path)
train_path = File.path('/Users/mattiagiuffrida/Development/RubymineProjects/fann/connect4/train_data/level-3.train')
train = RubyFann::TrainData.new(filename: train_path)
train.shuffle
player_x = Players::Fann.new(fann, 'X')
player_o = Players::MinMax.new('O') # MinMax AI can only play O for now
referee = Referee.new(:winner)
@saved_inputs = []
@saved_outputs = []

def save_move(fann, board, move)
  @saved_inputs << fann.board_data(board)
  @saved_outputs << [move]
end

# Clear some space
10.times { puts "\n" }

# Training loop
10.times do |i|
  board = Board.build(7, 6)

  # Game loop
  [player_x, player_o].cycle do |player|
    move = player.next_move(board)
    save_move(player_x, board, move) if player.is_a?(Players::MinMax)

    winner = referee.score(board)
    full = board.full?

    if full || winner != 0
      # puts ' ____________________'
      # puts '|                    |'
      # puts "|     MATCH #{i}     |"
      # puts '|____________________'
      # board.output(erase_before: false)

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

  ## Train fann with game output

  fann.train_on_data(train, 1000, 1001, MSE)
  @last_board = board
end

@last_board.output(erase_before: false)

## Save fann
fann.save(fann_path)
