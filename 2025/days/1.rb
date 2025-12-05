# frozen_string_literal: true

require_relative '../lib/solution'

class Day01 < Solution
  def part_one
    dial = 50
    zeroed = 0

    parse_rotations.each do |direction, rotation|
      dial = rotate(dial, direction, rotation)
      zeroed += 1 if dial.zero?
    end

    zeroed.to_s
  end

  def part_two
    dial = 50
    zeroed = 0

    parse_rotations.each do |direction, rotation|
      zeroed += count_zero_crossings(dial, direction, rotation)
      dial = rotate(dial, direction, rotation)
    end

    zeroed.to_s
  end

  private

  def parse_rotations
    input_lines.reject(&:empty?).map do |line|
      [line[0], line.scan(/\d+/)[0].to_i]
    end
  end

  def rotate(dial, direction, rotation)
    if direction == 'L'
      (dial - rotation) % 100
    else
      (dial + rotation) % 100
    end
  end

  def count_zero_crossings(dial, direction, rotation)
    if direction == 'L'
      if dial.zero?
        rotation / 100
      elsif rotation >= dial
        1 + (rotation - dial) / 100
      else
        0
      end
    else
      distance_to_zero = 100 - dial
      if rotation >= distance_to_zero
        1 + (rotation - distance_to_zero) / 100
      else
        0
      end
    end
  end
end

Day01.new.run if __FILE__ == $PROGRAM_NAME
