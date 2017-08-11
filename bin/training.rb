require 'ruby-fann'
require_relative '../lib/connect4'

# Constants
MSE = 0.001
FANN_PATH = File.path('/Users/mattiagiuffrida/Development/RubymineProjects/fann/connect4/networks/final.net')
TRAIN_PATH = File.path('/Users/mattiagiuffrida/Development/RubymineProjects/fann/connect4/training_csv/final.csv')

# Methods
def add_new_move(train_data, board_data, move)
  train_data.add(board_data, [move])
end

def run_training_round(train_data, epochs = 1000, report_each = 1001)
  puts "Running training on #{train_data.inputs.size} inputs."
  @fann = RubyFann::Standard.new(num_inputs: 42, hidden_neurons: [8], num_outputs: 1)
  train = RubyFann::TrainData.new(inputs: train_data.inputs, desired_outputs: train_data.outputs)
  train.shuffle

  @fann.train_on_data(train, epochs, report_each, MSE)
end

# Loading
train_data = TrainData.new(TRAIN_PATH)
run_training_round(train_data)

# Game setup
player_x = Players::Fann.new(@fann, 'X')
player_o = Players::MinMax.new('O') # MinMax AI can only play O for now
referee = Referee.new(:winner)
@saved_inputs = []
@saved_outputs = []

# Clear some space
10.times { puts "\n" }
loop = [player_o, player_x]

# Training loop
1000.times do |i|
  board = Board.build(7, 6)

  if loop.first == player_x
    loop = [player_o, player_x]
  else
    loop = [player_x, player_o]
  end

  # Game loop
  loop.cycle do |player|
    board_data = player_x.board_data(board)
    move = player.next_move(board) rescue break
    add_new_move(train_data, board_data, move) if player.is_a?(Players::MinMax)

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
  train_data.save
  run_training_round(train_data)
  @last_board = board
  board.output(erase_before: false)# if i % 10 == 0
end

@last_board.output(erase_before: false)

## Save fann
@fann.save(FANN_PATH)
