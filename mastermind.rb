class Hash
  def shuffle
    Hash[self.to_a.sample(self.length)]
  end
end

class Creator
  @@colors = {red: "🔴", orange: "🟠", yellow: "🟡", green: "🟢", blue: "🔵", brown: "🟤", black: "⚫", white: "⚪"}
  @@code = []
  @@code_strs = []
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
end

class Guesser
  def self.play_round
    @@current_guess = gets.split
    push_me = []
    push_me_2 = []
    @@current_guess.each_with_index do |el, i|
      if el == Creator.strs[i] && push_me.none?(el)
        Board.incr_clue(0)
        push_me.push(el)
      elsif el != Creator.strs[i] && Creator.strs.include?(el) && push_me_2.none?(el)
        Board.incr_clue(1)
        push_me_2.push(el)
      end
    end
  end

  def self.play_game
    i = 11
    puts "Enter 4 of the color names to guess the code, e.g. 'red orange yellow green'. The code will not repeat colors, but Guesser may repeat colors in their guess. The clue is displayed in brackets for each turn -- the first number is the number of colors that are correct but in the right position, and the second number is the number of colors that are correct but in the wrong position."
    puts Creator.colors.values.join' '
    12.times do
      puts "Enter next choice." if i < 11
      Board.reset_clue
      Guesser.play_round
      if Guesser.current_guess == Creator.strs
        puts "Guesser wins!"
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

  def self.current_guess
    @@current_guess
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

Guesser.play_game