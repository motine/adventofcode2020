class Passport
  REQUIRED_KEYS = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid] # optional :cid

  def initialize(pairs)
    @pairs = pairs
  end

  def valid?
    REQUIRED_KEYS.all? { |required_key| @pairs.keys.include?(required_key) }
  end

  def self.parse(str)
    pairs = {}
    str.scan(/([\w]+):([\#\w]+)(\s|$)/) do |key, value|
      pairs[key.to_sym] = value
    end
    self.new(pairs)
  end
end

passports = File.read('04.txt').split(/\n\n/).map { |line_group| Passport.parse(line_group) }
puts passports.select(&:valid?).count # => 264

