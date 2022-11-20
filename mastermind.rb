class Hash
  def shuffle
    Hash[self.to_a.sample(self.length)]
  end
end

class Creator
  @@colors = {red: "🔴", orange: "🟠", yellow: "🟡", green: "🟢", blue: "🔵", brown: "🟤", black: "⚫", white: "⚪"}
  @@code = []

  def self.set_code
    @@code = @@colors.shuffle
  end

  def self.code
    @@code
  end
end

class Guesser
  def self.play_round()
    puts "Guesser, guess the four-color code sequence."
    @@current_guess = gets.split
  end

  def self.current_guess
    @@current_guess
  end
end

class Board
  # @@clue = 
end

Creator.set_code

Guesser.play_round
