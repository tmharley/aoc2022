# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def full_contain?(assignments)
  elf1, elf2 = assignments.split(',')
  start1, end1 = elf1.split('-').map(&:to_i)
  start2, end2 = elf2.split('-').map(&:to_i)
  (start1..end1).cover?(start2..end2) || (start2..end2).cover?(start1..end1)
end

def overlap?(assignments)
  elf1, elf2 = assignments.split(',')
  start1, end1 = elf1.split('-').map(&:to_i)
  start2, end2 = elf2.split('-').map(&:to_i)
  ((start1..end1).to_a & (start2..end2).to_a).any?
end

REAL_INPUT = import_from_file('day04_input.txt')

def part_one(input)
  assignments = input.split("\n")
  conflicts = 0
  assignments.each { |a| conflicts += 1 if full_contain?(a) }
  conflicts
end

def part_two(input)
  assignments = input.split("\n")
  conflicts = 0
  assignments.each { |a| conflicts += 1 if overlap?(a) }
  conflicts
end

p part_one(TEST_INPUT) # should be 2
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 4
p part_two(REAL_INPUT)