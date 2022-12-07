# frozen_string_literal: true

def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day07_testinput.txt')
REAL_INPUT = import_from_file('day07_input.txt')

TOTAL_SPACE = 70_000_000
REQUIRED_SPACE = 30_000_000

def path_to_s(path)
  str = path.join('/')[1..]
  str == '' ? '/' : str
end

def parents(path_str)
  return [] if ['', '/'].include?(path_str)

  parent = path_str.split('/')[...-1].join('/')
  return ['/'] if parent == ''

  Array(parent) + parents(parent)
end

def build_tree(input)
  current_path = []
  tree = {}
  input.lines(chomp: true).each do |line|
    if line.start_with?('$') # command
      command, arg = line.split[1..]
      case command
      when 'cd'
        arg == '..' ? current_path.delete_at(-1) : current_path << arg
      when 'ls'
        tree[path_to_s(current_path)] = 0
      end
    else
      # output of `ls`
      info, name = line.split
      tree[path_to_s(current_path)] += info.to_i
      parents(path_to_s(current_path)).each do |dir|
        tree[dir] += info.to_i
      end
    end
  end
  tree
end

def part_one(input)
  tree = build_tree(input)
  tree.values.select { |v| v < 100_000 }.sum
end

def part_two(input)
  candidates = {}
  tree = build_tree(input)
  free_space = TOTAL_SPACE - tree['/']
  tree.each do |k, v|
    candidates[k] = v if free_space + v >= REQUIRED_SPACE
  end
  candidates.values.min
end

p part_one(TEST_INPUT) # should be 95437
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 24933642
p part_two(REAL_INPUT)