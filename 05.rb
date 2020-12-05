class BoardingPass
  def initialize(row, column)
    @row, @column = row, column
  end

  def identifier
    @row * 8 + @column
  end

  def self.parse(str)
    _, row_code, column_code = str.match(/^(\w{7})(\w{3})/).to_a
    row = convert_to_binary(row_code, 'B')
    column = convert_to_binary(column_code, 'R')
    self.new(row, column)
  end

  def self.convert_to_binary(str, one_char)
    str.chars.map { |char| char == one_char ? '1' : '0' }.join.to_i(2)
  end
end

puts File.readlines('05.txt').map { |str| BoardingPass.parse(str) }.map(&:identifier).max
