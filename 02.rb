class Line
  def initialize(rule, password)
    @rule, @password = rule, password
  end

  def valid?
    @rule.valid?(@password)
  end

  def self.parse(str)
    rule_str, password = str.split(':')
    rule = Rule.parse(rule_str)
    self.new(rule, password)
  end
end

class Rule
  def initialize(letter, lbound, ubound)
    @letter, @lbound, @ubound = letter, lbound, ubound
  end

  def valid?(str)
    bounds.include?(str.count(@letter))
  end

  def bounds
    @lbound..@ubound
  end

  def self.parse(str)
    range, letter = str.split(' ')
    lower, upper = str.split('-').map(&:to_i)
    self.new(letter, lower, upper)
  end
end

puts File.readlines('02.txt').map { |str| Line.parse(str) }.select(&:valid?).count # => 560