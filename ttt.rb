
#@Gnuvse
# 2023_12_1


# to-do 
# Играть с другим игроком, а не cpu
# Разнести по файлам
# сделать поле больше, check_win? маштабируема, с независимым набором поля

# bugs
# пересмотреть логику проверки выйгрыша #start_game, who_win?, check_win?
#
# При игре, приходится проверять в start_game через 3 хода, чтобы быть уверенным, 
# что cработает check_win, т.к. 

@table = [
  ["?", "?", "?"],
  ["?", "?", "?"],
  ["?", "?", "?"],
]



def reset_table()
  @table = [
    ["?", "?", "?"],
    ["?", "?", "?"],
    ["?", "?", "?"],
  ]
end


def empty_field?(row, column)
  if @table[row-1][column-1] == '?'
    return true
  else
    return false
  end
end


def update_table(row, column, symbol)
  if empty_field?(row, column)
    @table[row-1][column-1] = symbol
  else
    puts "This field is already taken:"
    player_input()
  end
end


def show_table()
  @table.each do |x|
    print x
    puts
  end
end


def valid_player_data?(data)
  if data >= 1 or data <= 3
    return true
  else
    return false
  end
end


def valid_player_symbol?(symbol)
  case symbol
  when 'x', 'X'
    return true
  when 'o', 'O'
    return true
  else
    return false
  end
end


def player_input(symbol)
  puts "Choice Row 1, 2, 3: "
  row = gets.to_i
  unless valid_player_data?(row)
    puts ("Wrong row data, #{row} is not valid")
    exit
  end

  puts "Choice Column 1, 2, 3: "
  column = gets.to_i
  unless valid_player_data?(column)
    puts ("Wrong row data, #{row} is not valid")
    exit
  end

  if valid_player_symbol?(symbol)
    update_table(row, column, symbol)
  else
    puts "Wrong symbol data, #{symbol} is not valid"
  end
end


def cpu_input(cpu_symbol)
  row = rand(1..3)
  column = rand(1..3)

  if empty_field?(row, column)
    update_table(row, column, cpu_symbol)
  else
    cpu_input(cpu_symbol)
  end
end

def cpu_choice_symbol(player_symbol)
  case player_symbol
  when 'x', 'X'
    return 'O'
  when 'o', 'O'
    return 'X'
  end
end


def check_win?(symbol)
  symbol = symbol.upcase
  flag_win = false
  # comb 1 ---
  @table.each do |row|
    row.each do |sym|
      if sym == symbol
        flag_win = true
      else
        flag_win = false
      end
    end
    return true if flag_win
  end

  # comb 2 |
  column = 0
  for i in 0..@table.size-1
    for j in 0..@table.size-1
      if @table[j][column] == symbol
        flag_win = true
      else
        flag_win = false
      end
    end
    return true if flag_win
    column += 1
  end


  # comb 3 \
  j = 0
  for i in 0..@table.size-1
    if @table[i][j] == symbol
      flag_win = true
    else
      flag_win = false
    end
    j+=1
  end

  # comb 4 /
  j = 2
  for i in (@table.size-1).downto(0)
    if @table[i][j] == symbol
      flag_win = true
    else
      flag_win = false
    end
    j-=1
  end

  return flag_win
end


def who_win?(symbol, cpu_symbol)
   if check_win?(symbol)
      puts "You win"
      puts "Do you want to play again? (y/n):"
      answer = gets.chomp
      if answer == 'y'
        start_game()
      else
        puts "Good bye"
      end
   elsif check_win?(cpu_symbol)
      puts "You lose"
      puts "Do you want to play again? (y/n):"
      answer = gets.chomp
      if answer == 'y'
        start_game()
      else
        puts "Good bye"
      end
   end
end



def start_game()
  puts "Tic-Tac-Toe"
  puts "Start"
  reset_table

  puts "Which symbol do you want to input on the table(X. O)?"
  symbol = gets.chomp
  cpu_symbol = cpu_choice_symbol(symbol)

  puts "CPU plays with #{cpu_symbol}"

  ##
  check_idx=0

  loop do
    show_table
    player_input(symbol)
    cpu_input(cpu_symbol)
    check_idx += 1
    if check_idx % 3 == 0
      who_win?(symbol, cpu_symbol)
    end
  end
end
