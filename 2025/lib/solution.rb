# frozen_string_literal: true

class Solution
  attr_reader :input

  def initialize
    @input = File.read('input.txt')
  end

  def input_lines
    @input_lines ||= @input.lines.map(&:chomp)
  end

  def part_one
    raise NotImplementedError, 'Subclass must implement part_one'
  end

  def part_two
    raise NotImplementedError, 'Subclass must implement part_two'
  end

  def run
    puts "Part 1: #{part_one}"
    puts "Part 2: #{part_two}"
  end
end
