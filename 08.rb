module Instruction
  module_function

  def run(operation_name, program, *params)
    send(operation_name, program, *params)
  end

  def nop(program, param)
  end

  def acc(program, param)
    program.accumulator += param.to_i
  end

  def jmp(program, param)
    program.counter += param.to_i
  end
end

class Program
  class RanBefore < StandardError; end
  class Unchanged < StandardError; end

  # may be modified by Instructions
  attr_accessor :accumulator
  attr_accessor :counter

  def initialize
    @instructions = [] # [ ['ope', ['param1', 'param2'], false] ]
    @instruction_indexes_run_before = []
    @accumulator = 0
    @counter = 0
  end

  # def initialize_copy(original_program)
  #   @instructions = original_program.instance_variable_get(:@instructions).collect { |instruction| instruction.dup }
  #   @accumulator = 0
  #   @counter = 0
  # end

  def instruction_count
    @instructions.count
  end

  def run
    loop do
      raise RanBefore if @instruction_indexes_run_before.include?(@counter)
      @instruction_indexes_run_before << @counter

      operation, params = @instructions[@counter]

      counter_before = @counter
      Instruction.run(operation, self, *params)
      @counter += 1 if counter_before == @counter # we only move forward if there was no change to the counter
    end
  end

  def parse(lines)
    @instructions = lines.collect do |line|
      operation, *params = line.split(' ')
      [operation, params]
    end
  end

  # def repair(instruction_index)
  #   instruction = @instructions[instruction_index]
  #   if instruction.is_a?(Instruction::Nop)
  #     @instructions[instruction_index] = Instruction::Jmp.new(self, instruction.param)
  #   elsif instruction.is_a?(Instruction::Jmp)
  #     @instructions[instruction_index] = Instruction::Nop.new(self, instruction.param)
  #   else
  #     raise Unchanged
  #   end
  # end

  # def inspect # TODO remove
  #   @instructions.collect {|instruction| instruction.class.name[-3..-1] }.join(', ')
  # end
end

program = Program.new
program.parse(File.readlines('08.txt'))

# part 1
begin
  program2 = program.dup
  program2.run
rescue Program::RanBefore
  puts "part 1: #{program2.accumulator}" # => 1394
end

# # part 2
# (0..program.instruction_count).each do |i|
#   varied_program = program.dup
#   # varied_program.repair(i)
#   varied_program.run
#   puts "part 2: #{varied_program.accumulator}"
#   break
# rescue Program::Unchanged
#   # ignore unchanged programs
# rescue Instruction::RanBefore
#   puts "xxx" + varied_program.accumulator.to_s
#   # ignore non-terminating program
# end