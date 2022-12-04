require 'bundler'
Bundler.require(:default)

def get_score(choice)
  case choice
  when 'A', 'X' # Rock
    1
  when 'B', 'Y' # Paper
    2
  when 'C', 'Z' # Scissors
    3
  else
    ap choice
    raise 'Bad input'
  end
end

def is_draw(opponent, me)
  opponent == 'A' && me == 'X' ||
  opponent == 'B' && me == 'Y' ||
  opponent == 'C' && me == 'Z'
end

def did_win(opponent, me)
  return nil if is_draw(opponent, me)
  (
    opponent == 'A' && me == 'Y' || # Rock vs Paper
    opponent == 'B' && me == 'Z' || # Paper vs Scissors
    opponent == 'C' && me == 'X'    # Scissors vs Rock
  ) || false
end

def counter_move(opponent, force_result)
  case opponent
  when 'A'
    if force_result == 'X'
      'Z'
    elsif force_result == 'Y'
      'X'
    elsif force_result == 'Z'
      'Y'
    end
  when 'B'
    if force_result == 'X'
      'X'
    elsif force_result == 'Y'
      'Y'
    elsif force_result == 'Z'
      'Z'
    end
  when 'C'
    if force_result == 'X'
      'Y'
    elsif force_result == 'Y'
      'Z'
    elsif force_result == 'Z'
      'X'
    end
  end
end

my_total = 0

File.open("#{__dir__}/input.txt") do |f|
  f.each_line do |line|
    opponent, result = line.split(' ')
    me = counter_move(opponent, result)
    case did_win(opponent, me)
    when false
      my_total += 0
    when nil
      my_total += 3
    when true
      my_total += 6
    else
      raise 'bad win result'
    end
    my_total += get_score(me)
  end
end

ap my_total
