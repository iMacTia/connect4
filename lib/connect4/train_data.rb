class TrainData
  attr_reader :inputs, :outputs, :file_path

  def initialize(file_path)
    @file_path = file_path # Remember file_path for auto-save
    @inputs = []
    @outputs = []
    File.foreach(file_path) do |line|
      data = line.gsub("\n", '').split(',').map(&:to_f)
      outputs << [data.pop / 10]
      inputs << data
    end
  end

  def save(file_path = nil)
    file_path ||= self.file_path
    File.open(file_path, 'w') do |file|
      inputs.size.times do |i|
        file.write("#{inputs[i].map(&:to_i).join(',')},#{outputs[i][0].round}\n")
      end
    end
  end

  def add(input, output)
    raise 'Inputs and outputs MUST be arrays.' unless inputs.is_a?(Array) and outputs.is_a?(Array)
    self.inputs << input
    self.outputs << output
  end
end