require 'bundler'
Bundler.require(:default)

pairs = []

def ranges_overlap?(a, b)
  !(a.first > b.last || a.last < b.first)
end

File.open("#{__dir__}/input.txt") do |f|
  f.each_line do |line|
    elf1_range = line.chomp.split(',')[0].split('-')
    elf2_range = line.chomp.split(',')[1].split('-')
    elf1_range = (elf1_range[0].to_i..elf1_range[1].to_i)
    elf2_range = (elf2_range[0].to_i..elf2_range[1].to_i)
    pairs << [elf1_range, elf2_range]
  end
end

total_covers = 0


puts 'Total covers'
puts pairs.map { |pair| pair[0].cover?(pair[1]) || pair[1].cover?(pair[0]) }.select { |x| x }.length

puts 'Total overlaps'
puts pairs.map { |pair| ranges_overlap?(pair[0], pair[1]) }.select { |x| x }.length
