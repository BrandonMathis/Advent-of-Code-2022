require 'bundler'
Bundler.require(:default)

myinput = File.read("#{__dir__}/input.txt")

input1 = 'bvwbjplbgvbhsrlpgdmjqwftvncz'
input = myinput

chars_processed = 0
buffer = []
buffer_size = 14

input.chars.each do |c|
  chars_processed += 1
  buffer << c
  if buffer.length > buffer_size
    buffer.shift
  end

  next if buffer.length != buffer_size

  if buffer.length == buffer.uniq.length
    puts chars_processed 
    break
  end
end
