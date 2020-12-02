class Line
  def initialize(rule, password)
    @rule, @password = rule, password
  end

  def valid?
    @rule.valid?(@password)
  end

  def self.parse(str, ruleClass)
    rule_str, password = str.split(':')
    rule = ruleClass.parse(rule_str)
    self.new(rule, password.strip)
  end
end

class Rule
  def initialize(letter, no1, no2)
    @letter, @no1, @no2 = letter, no1, no2
  end

  def valid?(str)
  end

  def self.parse(str)
    range, letter = str.split(' ')
    lower, upper = str.split('-').map(&:to_i)
    self.new(letter, lower, upper)
  end
end

class OldRule < Rule
  def valid?(str)
    (@no1..@no2).include?(str.count(@letter))
  end
end

class NewRule < Rule
  def valid?(str)
    (str[@no1-1] == @letter) ^ (str[@no2-1] == @letter)
  end
end

contents = File.readlines('02.txt')

puts contents.map { |str| Line.parse(str, OldRule) }.select(&:valid?).count # => 560
puts contents.map { |str| Line.parse(str, NewRule) }.select(&:valid?).count # => 560