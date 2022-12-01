require 'bundler'
Bundler.require(:default)

elf_inventory = [[]]

File.open("#{__dir__}/input.txt") do |f|
  f.each_line do |line|
    if line === "\n"
      elf_inventory << []
    else
      elf_inventory[-1] << line.chomp.to_i
    end
  end
end
elf_inventory = elf_inventory.map { |line| line.sum }

ap elf_inventory.max(3).sum
