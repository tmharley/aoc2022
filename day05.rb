# frozen_string_literal: true

TEST_INPUT = <<~INPUT
      [D]    
  [N] [C]    
  [Z] [M] [P]
   1   2   3 

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

REAL_INPUT = import_from_file('day05_input.txt')

class Stack
  def initialize
    @top_crate = nil
  end

  def push(crate)
    old_top = @top_crate
    @top_crate = crate
    @top_crate.next = old_top
  end

  def pop
    c = @top_crate
    @top_crate = c.next
    c
  end

  def add(new_top, num_crates)
    old_top = @top_crate
    @top_crate = c = new_top
    (num_crates - 1).times { c = c.next }
    c.next = old_top
  end

  def remove(num_crates)
    c = new_top = @top_crate
    num_crates.times { new_top = new_top.next }
    @top_crate = new_top
    c
  end

  def top_label
    @top_crate.label
  end
end

class Crate
  attr_accessor :label
  attr_accessor :next

  def initialize(label)
    self.label = label
  end
end

def parse_stacks(input)
  num_stacks = input.lines.last.chomp.split.last.to_i
  stacks = Array.new(num_stacks) { Stack.new }
  input.lines[...-1].reverse_each do |line|
    (0...num_stacks).each do |slot|
      label = line[slot * 4 + 1]
      unless label == ' '
        stacks[slot].push(Crate.new(label))
      end
    end
  end
  stacks
end

def part_one(input)
  stack_list, instructions = input.split("\n\n")
  stacks = parse_stacks(stack_list)
  instructions.lines(chomp: true).each do |line|
    match_data = /(\d+).*(\d+).*(\d+)/.match(line)
    move, from, to = match_data[1..3].map(&:to_i)
    move.times do
      stacks[to - 1].push(stacks[from - 1].pop)
    end
  end
  stacks.map(&:top_label).join('')
end

def part_two(input)
  stack_list, instructions = input.split("\n\n")
  stacks = parse_stacks(stack_list)
  instructions.lines(chomp: true).each do |line|
    match_data = /(\d+).*(\d+).*(\d+)/.match(line)
    move, from, to = match_data[1..3].map(&:to_i)
    stacks[to - 1].add(stacks[from - 1].remove(move), move)
  end
  stacks.map(&:top_label).join('')
end

p part_one(TEST_INPUT) # should be CMZ
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be MCD
p part_two(REAL_INPUT)