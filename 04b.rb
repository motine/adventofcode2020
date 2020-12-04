module Validation
  def validate(key, &validator)
    @validations ||= {}
    @validations[key] = validator
  end

  def validations
    @validations
  end
end

class Passport
  extend Validation

  validate(:byr) { |value| value.size == 4 && (1920..2002).include?(value.to_i) } # Birth Year
  validate(:iyr) { |value| value.size == 4 && (2010..2020).include?(value.to_i) } # Issue Year
  validate(:eyr) { |value| value.size == 4 && (2020..2030).include?(value.to_i) } # Expiration Year
  validate(:hgt) { |value| Passport.validate_height(value) } # Height
  validate(:hcl) { |value| !!(value =~ /^\#\h{6}$/) } # Hair Color
  validate(:ecl) { |value| %w[amb blu brn gry grn hzl oth].include?(value) } # Eye Color
  validate(:pid) { |value| !!(value =~ /^\d{9}$/) } # Passport ID

  def initialize(pairs)
    @pairs = pairs
  end

  def valid?
    self.class.validations.each do |key, validator|
      value = @pairs[key]
      return false if value.nil? || value.empty? # a validator implies required presence
      return false unless validator.call(value)
    end
    true
  end

  def self.parse(str)
    pairs = {}
    str.scan(/([\w]+):([\#\w]+)(\s|$)/) do |key, value|
      pairs[key.to_sym] = value
    end
    self.new(pairs)
  end

  def self.validate_height(value)
    number = value.to_i
    return (150..193).include?(number) if value.end_with?('cm')
    return (59..76).include?(number) if value.end_with?('in')
    return false
  end
end

passports = File.read('04.txt').split(/\n\n/).map { |line_group| Passport.parse(line_group) }
puts passports.select(&:valid?).count # => 225

