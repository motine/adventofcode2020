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

numbers = File.readlines('09.txt').map { |line| line.to_i }

buffer = ValidatingBuffer.new
numbers.each do |number|
  buffer << number
rescue ValidatingBuffer::InvalidSequence
  p number
  break
end
