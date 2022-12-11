# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day11_testinput.txt')
REAL_INPUT = import_from_file('day11_input.txt')

class Monkey
  attr_accessor :items
  attr_reader :total_inspections
  attr_writer :div_test

  def process(monkeys, high_worry: false)
    items.each do |item|
      @total_inspections += 1
      wl = item.worry_level
      wl = @operation.(wl)
      wl /= 3 unless high_worry
      if (wl % @div_test[0]).zero?
        item.worry_level = wl % monkeys.map(&:divisibility).reduce(:*)
        monkeys[@div_test[1]].items << item
      else
        item.worry_level = wl % monkeys.map(&:divisibility).reduce(:*)
        monkeys[@div_test[2]].items << item
      end
    end
    items.clear
  end

  def operation=(op)
    @operation = eval(op)
  end

  def initialize
    @total_inspections = 0
  end

  def divisibility
    @div_test[0]
  end
end

class Item
  attr_accessor :worry_level

  def initialize(wl)
    @worry_level = wl
  end
end

def parse(input)
  monkeys = []
  definitions = input.split("\n\n")
  definitions.each do |d|
    monkeys << (monkey = Monkey.new)
    test_params = []
    d.lines(chomp: true).each do |l|
      a, b = l.split(':')
      next if b.nil?

      case a.lstrip
      when 'Starting items'
        monkey.items = b.split(',').map { |i| Item.new(i.to_i) }
      when 'Operation'
        monkey.operation = b.sub('new =', '->(old) {') + ' }'
      when 'Test'
        test_params[0] = /\d+/.match(b)[0].to_i # divisible by n
      when 'If true'
        test_params[1] = /\d+/.match(b)[0].to_i # throw to monkey a
      when 'If false'
        test_params[2] = /\d+/.match(b)[0].to_i # throw to monkey b
        monkey.div_test = test_params
      end
    end
  end
  monkeys
end

def part_one(input)
  monkeys = parse(input)
  20.times do
    monkeys.each { |monkey| monkey.process(monkeys) }
  end
  monkeys.map(&:total_inspections).max(2).reduce(&:*)
end

def part_two(input)
  monkeys = parse(input)
  10_000.times do
    monkeys.each { |monkey| monkey.process(monkeys, high_worry: true) }
  end
  monkeys.map(&:total_inspections).max(2).reduce(&:*)
end

p part_one(TEST_INPUT) # should be 10605
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 2713310158
p part_two(REAL_INPUT)