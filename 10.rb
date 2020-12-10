jolts = File.readlines('10.txt').map(&:to_i)
jolts << 0 # add the outlet
jolts << jolts.max + 3 # add the built in one
jolts.sort!

def differences(js)
  return js.zip(js.drop(1))[0..-2].map { |a, b| b - a }
end

ds = differences(jolts)
p ds.count(1) * ds.count(3) # => 2432

def valid?(js)
  return false if js.nil? || js.size <= 2
  differences(js).max <= 3
end

$cache = {}

def possibility_count(js)
  return $cache[js] if $cache[js]
  return 1 if !valid?(js)

  # this could be done much smarter, by investigating the first three numbers
  # if they all lead to valid we multiply by 3, if only the first two we multiply by 2, ... (or something along those lines)
  result = possibility_count(js[1..-1])
  result += possibility_count(js[2..-1]) if valid?([js[0]] + js[2..4])
  result += possibility_count(js[3..-1]) if valid?([js[0]] + js[3..4])
  $cache[js] = result
  return result
end

# jolts = [16,10,15,5,1,11,7,19,6,12,4,  0,22].sort # => 8
# jolts = [0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49, 52] # => 19208
p possibility_count(jolts) # => 453551299002368