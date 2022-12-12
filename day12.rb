# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day12_input.txt')
X = 0
Y = 1
Z = 2

def parse(input, single_start: true)
  translation = ('a'..'z').to_a.zip((1..26).to_a).to_h
  start_points = []
  i = -1
  grid = input.lines(chomp: true).map do |row|
    i += 1
    j = -1
    row.each_char.map do |point|
      j += 1
      unless single_start
        start_points << [i, j] if %w[a S].include?(point)
      end
      case point
      when 'S'
        start_points << [i, j] if single_start
        1
      when 'E'
        26
      else
        translation[point]
      end
    end
  end
  [grid, start_points]
end

def adjacent(location, grid)
  results = []
  xx = location[X]
  yy = location[Y]
  results << [xx - 1, yy] if location[X] > 0
  results << [xx + 1, yy] if location[X] < grid.length - 1
  results << [xx, yy - 1] if location[Y] > 0
  results << [xx, yy + 1] if location[Y] < grid[0].length - 1
  results
end

def iterate(location, grid, distances)
  distance = distances[location[X]][location[Y]] || 0
  height = grid[location[X]][location[Y]] || 1
  adjacent_points = adjacent(location, grid)
  adjacent_points.each do |point|
    point_height = grid[point[X]][point[Y]]
    next if distances[point[X]][point[Y]] && distances[point[X]][point[Y]] <= distance + 1
    next if (point_height || 26) > height + 1 # too high
    distances[point[X]][point[Y]] = distance + 1
    iterate(point, grid, distances) unless point_height.nil?
  end
end

def part_one(input, finish_point)
  grid, start_point = parse(input)
  distances = Array.new(grid.length) { Array.new(grid[0].length) { nil } }
  iterate(start_point[0], grid, distances)
  distances[finish_point[X]][finish_point[Y]]
end

def part_two(input, finish_point)
  grid, start_points = parse(input, single_start: false)
  distances = Array.new(start_points.length) { Array.new(grid.length) { Array.new(grid[0].length) { nil } } }
  start_points.each_with_index do |sp, idx|
    iterate(sp, grid, distances[idx])
  end
  distances.map { |dist| dist[finish_point[X]][finish_point[Y]] }.compact.min
end

p part_one(TEST_INPUT, [2, 5]) # should be 31
p part_one(REAL_INPUT, [20, 40])

p part_two(TEST_INPUT, [2, 5]) # should be 29
p part_two(REAL_INPUT, [20, 40])