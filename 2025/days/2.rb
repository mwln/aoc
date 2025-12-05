# frozen_string_literal: true

require_relative '../lib/solution'

class Day02 < Solution
  def part_one
    (input.strip.split(',').map do |s|
      s.split('-').map(&:to_i)
    end).each { |s| p s[1] - s[0] }
  end

  def part_two
    '0'
  end
end

Day02.new.run if __FILE__ == $PROGRAM_NAME
