class Rule
  def self.add_rule(color, contained_colors)
    @rules ||= {}
    @rules[color] = contained_colors
  end

  def self.contains?(color, desired_color)
    return true if color == desired_color
    contained_colors = @rules[color]
    return false if contained_colors.empty?
    contained_colors.any? { |cc| self.contains?(cc, desired_color) }
  end

  def self.colors_containing(desired_color)
    @rules.keys.select { |color| contains?(color, desired_color) }
  end

  # Example: vibrant salmon bags contain 1 vibrant gold bag, 2 wavy aqua bags, 1 dotted crimson bag.
  def self.parse(str)
    _, color, rest = str.match(/^([\w\s]+) bags contain (.+)\.$/).to_a
    contained_colors = str.scan(/\d+ ([\w\s]+) bags?/).flatten
    self.add_rule(color, contained_colors)
  end
end

File.readlines('07.txt').each { |str| Rule.parse(str) }
p Rule.colors_containing('shiny gold').count - 1 # we are counting the rule for the color itself so we subtract 1