jolts = File.readlines('10.txt').map(&:to_i)

jolts.sort!

differences = jolts.zip(jolts.drop(1))[0..-2].map { |a, b| b - a }
p (differences.count(1)+1) * (differences.count(3)+1)