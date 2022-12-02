# frozen_string_literal: true

OPPONENT_PLAYS = { 'A' => 1, 'B' => 2, 'C' => 3 }.freeze
RESPONSES = { 'X' => 1, 'Y' => 2, 'Z' => 3 }.freeze

TEST_INPUT = <<~INPUT
  A Y
  B X
  C Z
INPUT

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

def match_result(opponent, response)
  case opponent
  when 1 # rock
    return 6 if response == 2
    response == 1 ? 3 : 0
  when 2 # paper
    return 6 if response == 3
    response == 2 ? 3 : 0
  when 3 # scissors
    return 6 if response == 1
    response == 3 ? 3 : 0
  end
end

def score(opponent, response)
  match_result(opponent, response) + response
end

def part_one(input)
  input.split("\n").map do |line|
    opponent, response = line.split(' ')
    score(OPPONENT_PLAYS[opponent], RESPONSES[response])
  end.sum
end

def part_two(input)
  input.split("\n").map do |line|
    opponent, strategy = line.split(' ')
    your_play = case strategy
                when 'X' # you want to lose
                  (OPPONENT_PLAYS[opponent] - 2) % 3 + 1 # ugly hack because mod actually doesn't work cleanly on a 1-3 range, oops
                when 'Y' # you want to draw
                  OPPONENT_PLAYS[opponent]
                when 'Z' # you want to win
                  OPPONENT_PLAYS[opponent] % 3 + 1
                end
    score(OPPONENT_PLAYS[opponent], your_play)
  end.sum
end

REAL_INPUT = import_from_file('day02_input.txt')

p part_one(TEST_INPUT) # should be 15
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 12
p part_two(REAL_INPUT)