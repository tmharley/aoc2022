# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  30373
  25512
  65332
  33549
  35390
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day08_input.txt')

def visible?(grid, x, y)
  return true if x == 0 || y == 0 || x == grid.length - 1 || y == grid.length - 1

  height = grid[x][y]
  grid[x][...y].max < height ||
    grid[x][y + 1..].max < height ||
    grid[...x].map { |col| col[y] }.max < height ||
    grid[x + 1..].map { |col| col[y] }.max < height
end

def build_grid(lines)
  lines.map { |row| row.each_char.map(&:to_i) }
end

def part_one(input)
  visible_trees = 0
  grid = build_grid(input.lines(chomp: true))
  (0...grid.length).each do |x|
    (0...grid.length).each do |y|
      visible_trees += 1 if visible?(grid, x, y)
    end
  end
  visible_trees
end

def part_two(input)
  max_score = -1
  grid = build_grid(input.lines(chomp: true))
  (1...(grid.length - 1)).each do |x|
    (1...(grid.length - 1)).each do |y|
      max_height = grid[x][y]
      all_scores = []
      score = 0
      (x - 1).downto(0) do |xx|
        score += 1
        break if grid[xx][y] >= max_height
      end
      all_scores << score
      score = 0
      (x + 1).upto(grid.length - 1) do |xx|
        score += 1
        break if grid[xx][y] >= max_height
      end
      all_scores << score
      score = 0
      (y - 1).downto(0) do |yy|
        score += 1
        break if grid[x][yy] >= max_height
      end
      all_scores << score
      score = 0
      (y + 1).upto(grid.length - 1) do |yy|
        score += 1
        break if grid[x][yy] >= max_height
      end
      all_scores << score
      total = all_scores.reduce(:*)
      max_score = total if total > max_score
    end
  end
  max_score
end

p part_one(TEST_INPUT) # should be 21
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 8
p part_two(REAL_INPUT)