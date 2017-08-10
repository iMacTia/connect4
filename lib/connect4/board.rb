require 'matrix'
require 'pp'

class Board < Matrix
  def self.build(width, height)
    super(height, width) { '.' }
  end

  alias_method :width, :column_count
  alias_method :height, :row_count

  def drop_coin(column, sign)
    height.times do |y|
      row = height-1-y
      if self[column, row] == '.'
        self[column, row] = sign
        break
      end
    end
  end

  def column_full?(column)
    height.times do |row|
      if self[column, row] == '.'
        return false
      end
    end
    true
  end

  def full?
    width.times do |column|
      unless column_full?(column)
        return false
      end
    end
    true
  end

  def []=(y,x,e)
    super(x,y,e)
  end

  def [](y,x)
    super(x,y)
  end

  def simple_render
    str = ''
    self.each_with_index do |e, row, col|
      str += "#{e}"
      if col == width-1
        str+= "\n"
      end
    end
    str
  end

  def output(erase_before: false)
    puts "\e[#{height+3}A" if erase_before
    puts self
  end

  def to_s
    str = "0123456\n"
    self.each_with_index do |e, row, col|
      str+= "\e[32mX\e[0m" if e == 'X'
      str+= "\e[31mO\e[0m" if e == 'O'
      str+= '.' if e == '.'
      str+= "\n" if col == width-1
    end
    str
  end
end
