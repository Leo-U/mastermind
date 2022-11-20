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
end

class Guesser
  def self.play_round
    puts "Guesser, guess the four-color, non-repeating code sequence. Enter space-separated list."
    @@current_guess = gets.split
    p Creator.code.values
    @@current_guess.each_with_index do |el, i|
      if el == Creator.strs[i]
        Board.incr_clue(0)
      elsif el != Creator.strs[i] && Creator.strs.include?(el)
        Board.incr_clue(1)
      end
    end
    p Board.clue
  end

  def self.play_game
    12.times do
      Board.reset_clue
      Guesser.play_round
      if Guesser.current_guess == Creator.strs
        break
      end
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