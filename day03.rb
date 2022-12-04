# frozen_string_literal: true

TEST_INPUT = <<~INPUT
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
INPUT

PRIORITY_MAP = (('a'..'z').to_a + ('A'..'Z').to_a).zip((1..52).to_a).to_h

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def duplicate_item(rucksack)
  left = rucksack[0...(rucksack.length / 2)]
  right = rucksack[(rucksack.length / 2)..]
  left.each_char do |item|
    return item if right.include?(item)
  end
end

def find_badge(first_elf, second_elf, third_elf)
  first_elf.each_char do |item|
    return item if second_elf.include?(item) && third_elf.include?(item)
  end
end

REAL_INPUT = import_from_file('day03_input.txt')

def part_one(input)
  input.split("\n").map { |rs| PRIORITY_MAP[duplicate_item(rs)] }.sum
end

def part_two(input)
  rucksacks = input.split("\n")
  (0...(rucksacks.length) / 3).map do |elf_group|
    badge = find_badge(rucksacks[elf_group * 3],
                       rucksacks[elf_group * 3 + 1],
                       rucksacks[elf_group * 3 + 2])
    PRIORITY_MAP[badge]
  end.sum
end

p part_one(TEST_INPUT) # should be 157
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 70
p part_two(REAL_INPUT)