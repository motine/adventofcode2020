class Map < Array
  def initialize(lines)
    super(lines.map(&:strip))
    @width = self.first.size
    @height = self.size
  end

  def tree?(x, y)
    self[y][x % @width] == '#'
  end

  def count_trees(x, y, step_x, step_y)
    return 0 if y >= @height
    cur_val = tree?(x, y) ? 1 : 0
    count_trees(x + step_x, y + step_y, step_x, step_y) + cur_val
  end

  def self.parse(lines)
    self.new(lines)
  end
end

map = Map.parse(File.readlines('03.txt'))
puts map.count_trees(3, 1, 3, 1)