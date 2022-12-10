# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day10_testinput.txt')
REAL_INPUT = import_from_file('day10_input.txt')

def part_one(input)
  x = 1
  instruction_num, add_amount, signal_strength = [0, 0, 0]
  lines = input.lines(chomp: true)
  220.times do |n|
    signal_strength += x * (n + 1) if (n + 1) % 40 == 20
    if add_amount.nonzero?
      x += add_amount
      add_amount = 0
      instruction_num += 1
    else
      inst = lines[instruction_num]
      inst == 'noop' ? instruction_num += 1 : add_amount = inst.split[1].to_i
    end
  end
  signal_strength
end

def part_two(input)
  x = 1
  instruction_num, add_amount = [0, 0]
  pixels = Array.new(240) { '.' }
  lines = input.lines(chomp: true)
  240.times do |n|
    pixels[n] = '#' if (x - 1..x + 1).include?(n % 40)
    if add_amount.nonzero?
      x += add_amount
      add_amount = 0
      instruction_num += 1
    else
      inst = lines[instruction_num]
      inst == 'noop' ? instruction_num += 1 : add_amount = inst.split[1].to_i
    end
  end
  (0...6).map { |y| pixels[y * 40...(y + 1) * 40].join('') }.join("\n")
end

p part_one(TEST_INPUT) # should be 13140
p part_one(REAL_INPUT)

pp part_two(TEST_INPUT)
pp part_two(REAL_INPUT)