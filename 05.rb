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

identifiers = File.readlines('05.txt').map { |str| BoardingPass.parse(str) }.map(&:identifier)
# first part
puts identifiers.max # => 904

# second part
# idea: we find a gap in the seat number codes (because they have to be sequential)
without_successor = identifiers.reject { |id| identifiers.include?(id + 1) }
gap_number = without_successor.sort.first + 1 # the last number shall not have a successor, so we can remove it
p gap_number