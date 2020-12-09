class Buffer
  def initialize(capacity=25)
    @capacity = capacity
    @values = []
  end

  def <<(value)
    @values << value
    @values.shift if @values.size > @capacity
    @values
  end

  def last
    @values.last
  end
end

class ValidatingBuffer < Buffer
  class InvalidSequence < StandardError; end

  def <<(value)
    if @values.size == @capacity # only validate if the preamble is over
      raise InvalidSequence unless @values.permutation(2).any? { |a,b| a+b == value }
    end
    super
  end
end

class Array
  def start_sequence_with_sum(target)
    0.upto(self.size-1) do |n|
      total = self[0..n].sum
      return self[0..n] if total == target
      return nil if total > target
    end
    return nil
  end
end

numbers = File.readlines('09.txt').map { |line| line.to_i }

weak_number = :not_found

buffer = ValidatingBuffer.new
numbers.each do |number|
  buffer << number
rescue ValidatingBuffer::InvalidSequence
  weak_number = number
  break
end

puts weak_number # => 248131121

sequence = numbers.dup
loop do
  sum_seq = sequence.start_sequence_with_sum(weak_number)
  if sum_seq
    puts sum_seq.min + sum_seq.max
    break
  end
  sequence.shift
  raise 'no result found' if sequence.empty?
end
# => 31580383
