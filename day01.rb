# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def parse(input)
  inventories = [[]]
  lines = input.split("\n").map!(&:chomp).map!(&:to_i)
  lines.each do |line|
    if line.zero?
      inventories << []
    else
      inventories.last << line
    end
  end
  inventories
end

def calorie_totals(inventories)
  inventories.map(&:sum)
end

TEST_INPUT = <<~INPUT
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
INPUT

REAL_INPUT = import_from_file('day01_input.txt')

def part_one(input)
  inventories = parse(input)
  calorie_totals(inventories).max
end

def part_two(input)
  inventories = parse(input)
  calorie_totals(inventories).max(3).sum
end

p part_one(TEST_INPUT) # should be 24000
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 45000
p part_two(REAL_INPUT)
