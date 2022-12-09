# frozen_string_literal: true

require 'set'

TEST_INPUT = <<~INPUT
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
INPUT

TEST_INPUT_2 = <<~INPUT
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day09_input.txt')
X = 0
Y = 1

def adjacent?(head, tail)
  Math.abs(head[X] - tail[X]) <= 1 && Math.abs(head[Y] - tail[Y]) <= 1
end

def make_adjacent(head, tail)
  if head[X] - tail[X] > 1
    tail[X] += 1
    if head[Y] - tail[Y] > 0
      tail[Y] += 1
    elsif tail[Y] - head[Y] > 0
      tail[Y] -= 1
    end
  elsif tail[X] - head[X] > 1
    tail[X] -= 1
    if head[Y] - tail[Y] > 0
      tail[Y] += 1
    elsif tail[Y] - head[Y] > 0
      tail[Y] -= 1
    end
  elsif head[Y] - tail[Y] > 1
    tail[Y] += 1
    if head[X] - tail[X] > 0
      tail[X] += 1
    elsif tail[X] - head[X] > 0
      tail[X] -= 1
    end
  elsif tail[Y] - head[Y] > 1
    tail[Y] -= 1
    if head[X] - tail[X] > 0
      tail[X] += 1
    elsif tail[X] - head[X] > 0
      tail[X] -= 1
    end
  end
end

def part_one(input)
  head = [0, 0]
  tail = [0, 0]
  tail_visited = Set.new
  input.lines(chomp: true).each do |line|
    dir, dist = line.split
    dist = dist.to_i
    case dir
    when 'U'
      dist.times do
        head[Y] += 1
        make_adjacent(head, tail)
        tail_visited << tail.dup
      end
    when 'D'
      dist.times do
        head[Y] -= 1
        make_adjacent(head, tail)
        tail_visited << tail.dup
      end
    when 'L'
      dist.times do
        head[X] -= 1
        make_adjacent(head, tail)
        tail_visited << tail.dup
      end
    when 'R'
      dist.times do
        head[X] += 1
        make_adjacent(head, tail)
        tail_visited << tail.dup
      end
    end
  end
  tail_visited.size
end

def part_two(input)
  rope = Array.new(10) { [0, 0] }
  head = rope[0]
  tail = rope[9]
  tail_visited = Set.new
  input.lines(chomp: true).each do |line|
    dir, dist = line.split
    dist = dist.to_i
    case dir
    when 'U'
      dist.times do
        head[Y] += 1
        (0...9).each { |n| make_adjacent(rope[n], rope[n + 1]) }
        tail_visited << tail.dup
      end
    when 'D'
      dist.times do
        head[Y] -= 1
        (0...9).each { |n| make_adjacent(rope[n], rope[n + 1]) }
        tail_visited << tail.dup
      end
    when 'L'
      dist.times do
        head[X] -= 1
        (0...9).each { |n| make_adjacent(rope[n], rope[n + 1]) }
        tail_visited << tail.dup
      end
    when 'R'
      dist.times do
        head[X] += 1
        (0...9).each { |n| make_adjacent(rope[n], rope[n + 1]) }
        tail_visited << tail.dup
      end
    end
  end
  tail_visited.size
end

p part_one(TEST_INPUT) # should be 13
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 1
p part_two(TEST_INPUT_2) # should be 36
p part_two(REAL_INPUT)