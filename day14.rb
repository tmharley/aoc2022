# frozen_string_literal: true

require 'set'

TEST_INPUT = <<~INPUT
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day14_input.txt')

def parse(input)
  blocked = Set.new
  max_y = -1
  input.lines(chomp: true).each do |line|
    points = line.split(' -> ')
    points.map! { |p| p.split(',').map(&:to_i) }
    points.each_with_index do |p, i|
      next if i.zero?
      curr = p
      last = points[i - 1]
      if curr[0] == last[0]
        range = curr[1] < last[1] ? curr[1]..last[1] : last[1]..curr[1]
        range.each { |pp| blocked << [curr[0], pp] }
      else
        range = curr[0] < last[0] ? curr[0]..last[0] : last[0]..curr[0]
        range.each { |pp| blocked << [pp, curr[1]] }
      end
      max_y = p[1] if p[1] > max_y
    end
  end
  [blocked, max_y]
end

def drop_sand(blocked_points, max_y, floor: false)
  location = [500, 0]

  loop do
    if floor
      return false if blocked_points.include?([500, 0])
    else
      return false if location[1] > max_y
    end
    move_to = [location[0], location[1] + 1]
    move_to = [location[0] - 1, location[1] + 1] if blocked_points.include?(move_to)
    move_to = [location[0] + 1, location[1] + 1] if blocked_points.include?(move_to)
    if blocked_points.include?(move_to) || location[1] == max_y + 1
      # floor is at max_y + 2, so must stop before that
      blocked_points << location
      break
    else
      location = move_to
    end
  end
  true
end

def part_one(input)
  blocked_points, max_y = parse(input)
  initial_blocked = blocked_points.size
  loop while drop_sand(blocked_points, max_y)
  blocked_points.size - initial_blocked
end
def part_two(input)
  blocked_points, max_y = parse(input)
  initial_blocked = blocked_points.size
  loop while drop_sand(blocked_points, max_y, floor: true)
  blocked_points.size - initial_blocked
end

p part_one(TEST_INPUT) # should be 24
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 93
p part_two(REAL_INPUT)