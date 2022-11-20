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
    puts "Guesser, type 4 of the following color names:"
    puts Creator.colors.values.join' '
    @@current_guess = gets.split
    push_me = []
    @@current_guess.each_with_index do |el, i|
      if el == Creator.strs[i] && push_me.none?(el)
        Board.incr_clue(0)
        push_me.push(el)
      elsif el != Creator.strs[i] && Creator.strs.include?(el) && push_me.none?(el)
        Board.incr_clue(1)
        push_me.push(el)
      end
    end
    p Creator.code.values
  end

  def self.play_game
    i = 11
    12.times do
      Board.reset_clue
      Guesser.play_round
      if Guesser.current_guess == Creator.strs
        break
      end
      # system("clear")
      puts "Attempts remaining: #{i}"
      p Board.clue
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