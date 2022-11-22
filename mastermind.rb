class Hash
  def shuffle
    Hash[self.to_a.sample(self.length)]
  end
end

class Creator
  @@colors = {red: "🔴", orange: "🟠", yellow: "🟡", green: "🟢", blue: "🔵", brown: "🟤", black: "⚫", white: "⚪"}

  def self.shuffle_code
    @@code = @@colors.shuffle.first(4).to_h
  end

  def self.set_code
    @@code_strs = @@code.keys.map {|el| el = el.to_s}
  end

  def self.code=(arg)
    @@code = arg
  end

  def self.code
    @@code
  end

  def self.strs=(arg)
    @@code_strs = arg
  end

  def self.strs
    @@code_strs
  end

  def self.colors
    @@colors
  end
end

class Guesser
  def self.current_guess
    @@current_guess
  end

  def self.current_guess=(guess)
    @@current_guess = guess
  end

  def self.play_round ()
    push_me = []
    iterate_me = @@current_guess.dup
    iterate_me.each_with_index do |el, i|
      if el == Creator.strs[i]
        Board.incr_clue(0)
        push_me.push(el)
      end
    end
    iterate_me.delete_if { |el| push_me.include?(el)}
    iterate_me.uniq.each { |el| Board.incr_clue(1) if Creator.strs.include?(el)}
  end

  def self.play_game
    i = 11
    puts "Enter 4 of the color names to guess the code, e.g. 'red orange yellow green'. The code will not repeat colors, but Guesser may repeat colors in their guess. The 2-digit clue is displayed in brackets for each turn — the first digit is the number of colors that are correct and in the right position, and the second digit is the number of colors that are correct but in the wrong position."
    puts Creator.colors.values.join' '
    12.times do
      puts "Enter next choice." if i < 11
      Board.reset_clue
      @@current_guess = gets.split
      Guesser.play_round
      if Guesser.current_guess == Creator.strs
        puts "Guesser wins!"
        puts Creator.code.values.join' '
        break
      end
      puts "Attempts remaining: #{i}"
      if i >= 1
        p Board.clue
      else 
        puts "Guesser failed. The code was #{Creator.code.values.join' '} ."
      end
      i -= 1
    end
  end
end

class Computer
  @@current_clue = []
  def self.crack_code
    set = (1111..8888).to_a.delete_if {|el| el.to_s.include?("0") || el.to_s.include?("9")}
    set = set.map {|el| el.to_s}.map do |el|
        el.gsub("1","red ").gsub("2","orange ").gsub("3","yellow ").gsub("4","green ").gsub("5","blue ").gsub("6","brown ").gsub("7","black ").gsub("8","white ").rstrip
    end
    Guesser.current_guess = "red red orange orange".split
    i = 11
    12.times do
      sleep(2)
      puts "The computer guesses '#{Guesser.current_guess.join' '}'."
      Board.reset_clue
      if Guesser.current_guess == Creator.strs
        puts "Computer wins!"
        puts Creator.code.values.join' '
        break
      end
      push_me = []
      Guesser.play_round
      p Board.clue
      puts "Attempts remaining: #{i}"
      clue_copy = Board.clue
      set.each do |el|
        Board.reset_clue
        code_copy = Creator.strs
        Creator.strs = el.split
        Guesser.play_round
        push_me.push(el) if Board.clue == clue_copy
        Creator.strs = code_copy
      end
      set = push_me
      Guesser.current_guess = set[0].split
      i -= 1
    end
  end
end

class Board
  @@clue = [0, 0]

  def self.incr_clue(index)
    @@clue[index] += 1
  end

  def self.clue
    @@clue
  end

  def self.reset_clue
    @@clue = [0,0]
  end
end

class Game
  def self.choose_side
    puts "Do you want to be the code guesser or the code chooser? Type 'guesser' or 'chooser'."
    @@active_player = gets.chomp
  end

  def self.play_game
    choose_side
    if @@active_player == "chooser"
      puts "To choose the code that the computer must guess, enter a space-separated, non-repeating list (e.g. 'red white blue yellow') of these colors:"
      puts "#{Creator.colors.values.join' '}"
      puts "For each turn, the computer will use the 2-digit clue you'll see in brackets — the first digit is the number of colors that are correct and in the right position, and the second digit is the number of colors that are correct but in the wrong position."
      code = gets.split
      code = code.map { |el| el.to_sym}
      push_me = []
      Creator.colors.each_pair do | key, value|
        if code.include?(key)
          push_me.push([key, value])
        end
      end
      Creator.code = push_me.to_h
      Creator.set_code
      Computer.crack_code
    elsif @@active_player == "guesser"
      Creator.shuffle_code
      Creator.set_code
      Guesser.play_game
    end
  end
end

Game.play_game
