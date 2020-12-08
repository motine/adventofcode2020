module Instructions
  class Base
    def initialize(program, param)
      @program, @param = program, param
      @ran_before = false
    end

    def run(increment_counter: true)
      @program.counter += 1 if increment_counter
      raise @program.accumulator.to_s if @ran_before
      @ran_before = true
    end
  end

  class Nop < Base
    def run
      super
    end
  end

  class Acc < Base
    def run
      super
      @program.accumulator += @param.to_i
    end
  end

  class Jmp < Base
    def run
      super(increment_counter: false)
      @program.counter += @param.to_i
    end
  end
end

class Program
  # may be modified by Instructions
  attr_accessor :accumulator
  attr_accessor :counter

  def initialize
    @instructions = []
    @accumulator = 0
    @counter = 0
  end

  def run
    loop do
      @instructions[@counter].run
    end
  end

  def parse(lines)
    @instructions = lines.collect do |line|
      operation, *params = line.split(' ')
      operation_class_name = "#{operation[0].upcase}#{operation[1..-1]}" # upcase first letter (poor mans titlize)
      operation_class = Instructions.const_get(operation_class_name)
      operation_class.new(self, *params)
    end
  end
end

program = Program.new
program.parse(File.readlines('08.txt'))
program.run