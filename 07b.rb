class RuleList
  def initialize
    @rules = {}
  end

  def add(color, containments)
    @rules[color] = containments
  end

  # Example: vibrant salmon bags contain 1 vibrant gold bag, 2 wavy aqua bags, 1 dotted crimson bag.
  def parse_line(str)
    _, color, rest = str.match(/^([\w\s]+) bags contain (.+)\.$/).to_a
    containments = str.scan(/(\d+) ([\w\s]+) bags?/).map { |count, color| Containment.new(color, count.to_i) }
    add(color, containments)
  end

  def bags_needed_for(color)
    containments = @rules[color]
    return 1 + containments.collect { |containment| containment.count * bags_needed_for(containment.color) }.sum # the bag itself + the multiplication of its containment counts
  end
end

class Containment < Struct.new(:color, :count)
end

rules = RuleList.new
File.readlines('07.txt').each { |str| rules.parse_line(str) }
p rules.bags_needed_for('shiny gold') - 1 # -1 because we do not count the shiny gold bag