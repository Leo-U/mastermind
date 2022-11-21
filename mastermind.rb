class Hash
  def shuffle
    Hash[self.to_a.sample(self.length)]
  end
end

class Creator
  @@colors = {red: "🔴", orange: "🟠", yellow: "🟡", green: "🟢", blue: "🔵", brown: "🟤", black: "⚫", white: "⚪"}
  def self.set_code
    @@code = @@colors.shuffle.first(4).to_h
    @@code_strs = @@code.keys.map {|el| el = el.to_s}
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
    puts "Enter 4 of the color names to guess the code, e.g. 'red orange yellow green'. The code will not repeat colors, but Guesser may repeat colors in their guess. The clue is displayed in brackets for each turn -- the first number is the number of colors that are correct but in the right position, and the second number is the number of colors that are correct but in the wrong position."
    puts Creator.colors.values.join' '
    12.times do
      puts "Enter next choice." if i < 11
      Board.reset_clue
      if ActivePlayer.chosen == "guesser"
        @@current_guess = gets.split
      elsif ActivePlayer.chosen == "creator"
        # @@current_guess = 
      end
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
    p Guesser.current_guess

  12.times do
    Board.reset_clue
    if Guesser.current_guess == Creator.strs
      puts "Guesser wins!"
      puts Creator.code.values.join' '
      break
    end
    push_me = []
    Guesser.play_round
    clue_copy = Board.clue
    p set.length
    set.each do |el|
      Board.reset_clue
      code_copy = Creator.strs
      Creator.strs = el.split
      Guesser.play_round
      push_me.push(el) if Board.clue == clue_copy
      Creator.strs = code_copy
    end
    set = push_me if push_me.length > 0
    Guesser.current_guess = set[0].split if push_me.length > 0
    p push_me.length
    p set[0]

    p Guesser.current_guess

  end

  



    # 12.times do
    #   Guesser.play_round
    #   if Guesser.current_guess == Creator.strs
    #     puts "Guesser wins!"
    #     puts Creator.code.values.join' '
    #     break
    #   end
    #   @@current_clue = Board.clue
    #   Board.reset_clue
    #   new_arr = []
    #   set.each do |el|
    #     Guesser.current_guess = el.split
    #     Guesser.play_round
    #     new_arr.push(el) if Board.clue == @@current_clue
    #     Board.reset_clue
    #   end
    #   set = new_arr
    #   Guesser.current_guess = set[0].split
    # end

    # set = set.filter do |el|
    #   Guesser.current_guess = 
    # end
  end
end

class ActivePlayer
  def self.gets_active_player
    puts "Do you want to be the code creator or the code guesser? Enter 'creator' or 'guesser'."
    @@chosen = gets.chomp
  end
  
  def self.chosen
    @@chosen
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

Creator.set_code
Computer.crack_code
# Creator.set_code
# ActivePlayer.gets_active_player
# Guesser.play_game