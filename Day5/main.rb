require 'bundler'
Bundler.require(:default)

class Stack
  attr_accessor :stack

  def initialize(stack)
    @stack = stack
  end

  def move_from_to(n, from, to)
    crane = stack[from].shift(n)
    stack[to].unshift(crane).flatten!
  end

  def pretty_print
    ap stack.map { |x| x.join('') }
  end
end

stack = Stack.new([
  %w(C F B L D P Z S),
    %w(B W H P G V N),
        %w(G J B W F),
  %w(S C W L F N J G),
  %w(H S M P T L J W),
      %w(S F G W C B),
    %w(W B Q M P T H),
          %w(T W S F),
            %w(R C N),
])


contents = File.read("#{__dir__}/input.txt").split(/^\n/)
x, instructions = contents

stack.pretty_print

instructions = instructions.split("\n").map do |instruction|
  instruction.match(/move (\d*) from (\d*) to (\d*)/).to_a.last(3).map &:to_i
end

instructions.each do |instruction|
  stack.move_from_to(instruction[0], (instruction[1] - 1), (instruction[2] - 1))
end

stack.pretty_print
puts stack.stack.map { |x| x.join }.map(&:chars).map(&:first).join
