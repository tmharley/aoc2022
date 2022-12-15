# frozen_string_literal: true

require 'set'

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day15_testinput.txt')
REAL_INPUT = import_from_file('day15_input.txt')

def manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

def parse(input)
  beacons = Set.new
  sensors = input.lines(chomp: true).map do |line|
    sensor_text, beacon_text = line.split(':')
    sx, sy = /=(-?\d+).*=(-?\d+)/.match(sensor_text)[1..2].map(&:to_i)
    bx, by = /=(-?\d+).*=(-?\d+)/.match(beacon_text)[1..2].map(&:to_i)
    beacons << [bx, by]
    { location: [sx, sy], min_distance: manhattan_distance(sx, sy, bx, by) }
  end
  [sensors, beacons]
end

def part_one(input, row_number)
  excluded = Set.new
  sensors, beacons = parse(input)
  sensors.each do |sensor|
    dist_to_row = (sensor[:location][1] - row_number).abs
    remaining_dist = sensor[:min_distance] - dist_to_row
    next if remaining_dist.negative?
    ((sensor[:location][0] - remaining_dist)..(sensor[:location][0] + remaining_dist)).each do |x|
      excluded << x
    end
  end
  excluded.size - beacons.select { |b| b[1] == row_number && excluded.include?(b[0]) }.size
end

def part_two(input, grid_size)
  sensors, _beacons = parse(input)
  exclude_x_plus_y = []
  exclude_x_minus_y = []
  sensors.each do |sensor|
    x_plus_y = sensor[:location][0] + sensor[:location][1]
    x_minus_y = sensor[:location][0] - sensor[:location][1]
    min_dist = sensor[:min_distance]
    exclude_x_plus_y << Range.new(x_plus_y - min_dist, x_plus_y + min_dist)
    exclude_x_minus_y << Range.new(x_minus_y - min_dist, x_minus_y + min_dist)
  end

  x = y = 0

  i = 0
  while i < exclude_x_plus_y.length
    if exclude_x_plus_y[i].include?(x + y) && exclude_x_minus_y[i].include?(x - y)
      # skip over the remainder of this region
      if sensors[i][:location][0] > x
        y = x - exclude_x_minus_y[i].min + 1
      else
        y = exclude_x_plus_y[i].max - x + 1
      end
      if y > grid_size
        y = 0
        x += 1
      end
      i = 0
    else
      i += 1
    end
  end
  x * 4_000_000 + y
end

p part_one(TEST_INPUT, 10) # should be 26
p part_one(REAL_INPUT, 2_000_000)

p part_two(TEST_INPUT, 20) # should be 56000011
p part_two(REAL_INPUT, 4_000_000)