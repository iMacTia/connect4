require 'ruby-fann'
require_relative '../lib/connect4/utils'

@level = ARGV[0]
raise 'Missing argument: level.' unless @level

@inputs = []
@outputs = []

File.foreach(join_path("../training_csv/level-#{@level}.csv")) do |line|
  data = line.gsub("\n", '').split(',').map(&:to_f)
  @outputs << [data.pop / 10]
  @inputs << data
end

train = RubyFann::TrainData.new(inputs: @inputs, desired_outputs: @outputs)
train.save(join_path("../train_data/level-#{@level}.train"))

fann = RubyFann::Standard.new(num_inputs: 42, hidden_neurons: [8], num_outputs: 1)
fann.save(join_path("../networks/level-#{@level}.net"))