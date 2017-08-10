require 'ruby-fann'
require_relative '../lib/connect4/utils'

MSE = 0.001

@level = ARGV[0].to_i
raise 'Missing arguments: level, ephocs.' unless @level

@ephocs = ARGV[1].to_i
raise 'Missing argument: ephocs.' unless @ephocs

@report_freq = (@ephocs / 100).to_i

# Load training data and fann
train = RubyFann::TrainData.new(filename: join_path("../train_data/level-#{@level}.train"))
fann = RubyFann::Standard.new(filename: join_path("../networks/level-#{@level}.net"))

# Train fann
fann.train_on_data(train, @ephocs, @report_freq, MSE)

# Save updated fann
fann.save(join_path("../networks/level-#{@level}.net"))


## To test
# require 'ruby-fann'
# require './lib/utils'
# def input_from(str)
#   str.split(' ').map(&:to_i)
# end
# fann = RubyFann::Standard.new(filename: join_path("../networks/level-3.net"))
# fann.run input_from("")
