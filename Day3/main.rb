require 'bundler'
Bundler.require(:default)

def get_priority(char)
  char_list = ('a'..'z').to_a + ('A'..'Z').to_a
  char_list.find_index(char) + 1
end

def get_priority_sum
  pocket_combos = []

  File.open("#{__dir__}/input.txt") do |f|
    f.each_line do |line|
      line = line.chomp
      pocket_combos << line.chars.each_slice(line.length / 2).map(&:join)
    end
  end

  duplicates = pocket_combos.map do |combo|
    combo[0].chars & combo[1].chars
  end.flatten

  priorities = duplicates.map { |dup| get_priority dup }

  priorities.sum
end

puts get_priority_sum

def get_triplet_groups
  groups = []
  File.open("#{__dir__}/input.txt") do |f|
    f.each_slice(3) do |line|
      line = line.map &:chomp
      groups << line
    end

    chars_in_common = groups.map do |group|
      group[0].chars & group[1].chars & group[2].chars
    end.flatten

    priorities = chars_in_common.map { |char| get_priority char }
    priorities.sum
  end
end

puts get_triplet_groups
