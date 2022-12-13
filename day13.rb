# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day13_testinput.txt')
REAL_INPUT = import_from_file('day13_input.txt')

def compare(left, right)
  left = Array(left)
  right = Array(right)
  result = nil
  return nil if left.empty? && right.empty?
  0.upto(left.length - 1) do |i|
    return false if i >= right.length
    if left[i].is_a?(Array) || right[i].is_a?(Array)
      result = compare(left[i], right[i])
      return result unless result.nil?
    else
      return true if left[i] < right[i]
      return false if left[i] > right[i]
    end
  end
  if result.nil?
    result = (left.length <= right.length)
  end
  result
end

def part_one(input)
  sum = 0
  pairs = input.split("\n\n")
  pairs.each_with_index do |pair, index|
    left_str, right_str = pair.split("\n")
    left = eval(left_str)
    right = eval(right_str)
    sum += (index + 1) if compare(left, right)
  end
  sum
end

def part_two(input)
  ordered_packets = []
  result = 1
  input.lines(chomp: true).each do |line|
    next if line == ''
    packet = eval(line)
    inserted = false
    (0...ordered_packets.length).each do |i|
      if compare(packet, ordered_packets[i])
        ordered_packets.insert(i, packet)
        inserted = true
        break
      end
    end
    ordered_packets << packet unless inserted
  end
  [[[2]], [[6]]].each do |divider|
    (0...ordered_packets.length).each do |i|
      if compare(divider, ordered_packets[i])
        ordered_packets.insert(i, divider)
        result *= (i + 1)
        break
      end
    end
  end
  result
end

p part_one(TEST_INPUT) # should be 13
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 140
p part_two(REAL_INPUT)