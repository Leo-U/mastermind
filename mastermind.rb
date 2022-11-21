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

  def self.strs
    @@code_strs
  end

  def self.colors
    @@colors
  end

  

  def self.play_game
    @@code_choice = gets.split
  end
end

class Guesser
  def self.current_guess
    @@current_guess
  end

  def self.play_round
    if ActivePlayer.chosen == "guesser"
      @@current_guess = gets.split
    elsif ActivePlayer.chosen == "creator"
      @@current_guess = input
    end
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

  def self.play_game (input = nil)
    i = 11
    puts "Enter 4 of the color names to guess the code, e.g. 'red orange yellow green'. The code will not repeat colors, but Guesser may repeat colors in their guess. The clue is displayed in brackets for each turn -- the first number is the number of colors that are correct but in the right position, and the second number is the number of colors that are correct but in the wrong position."
    puts Creator.colors.values.join' '

    12.times do
      puts "Enter next choice." if i < 11
      Board.reset_clue
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
ActivePlayer.gets_active_player
Guesser.play_game