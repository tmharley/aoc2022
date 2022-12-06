# frozen_string_literal: true

TEST_INPUT = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb'

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def marker_position(input, num_chars)
  check = {}
  index = 0
  input.each_char do |char|
    if check.key?(char)
      check[char] += 1
    else
      check[char] = 1
    end
    if index >= num_chars
      check[input[index - num_chars]] -= 1
    end
    return index + 1 if index >= num_chars && check.values.none? { |v| v > 1 }

    index += 1
  end
end

REAL_INPUT = import_from_file('day06_input.txt')

def part_one(input)
  marker_position(input, 4)
end

def part_two(input)
  marker_position(input, 14)
end

p part_one(TEST_INPUT) # should be 7
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 19
p part_two(REAL_INPUT)