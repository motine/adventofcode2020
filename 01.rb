class Array
  def multiply
    self.reduce(&:*)
  end
end

def result_for(n, sum_to_find)
  File.read('01.txt').split.map(&:to_i).permutation(n).find { |vals| vals.sum == sum_to_find }.yield_self { |vals| vals.multiply }
end

puts result_for(2, 2020) # => 658899
puts result_for(3, 2020) # => 155806250