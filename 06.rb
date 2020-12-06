require 'set'

class Answer
  attr_reader :yes_letters

  def initialize(yes_letters)
    @yes_letters = yes_letters
  end

  def self.parse(str)
    self.new(str.strip.chars)
  end
end

class Group
  def initialize(answers)
    @answers = answers
  end

  def any_yes_letters
    @answers.reduce(Set.new) { |memo, answer| memo.merge(answer.yes_letters) }
  end

  def all_yes_letters
    @answers.map { |answer| Set.new(answer.yes_letters) }.reduce { |memo, letter_set| memo & letter_set }
  end

  def self.parse(str)
    answers = str.strip.split("\n").map { |answer_str| Answer.parse(answer_str) }
    self.new(answers)
  end
end

groups = File.read('06.txt').split("\n\n").map { |group_str| Group.parse(group_str) }
p groups.map(&:any_yes_letters).map { |letters| letters.count }.sum # => 6878
p groups.map(&:all_yes_letters).map { |letters| letters.count }.sum # => 3464

