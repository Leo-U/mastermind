# frozen_string_literal: true

module CodeAndColorData
  def colors
    @colors = { red: '🔴', orange: '🟠', yellow: '🟡', green: '🟢', blue: '🔵', brown: '🟤', black: '⚫', white: '⚪' }
  end

  def shuffle_code
    @code = colors.to_a.sample(4).to_h
  end

  def map_code(code)
    @code_strs = code.keys.map(&:to_s)
  end

  def code=(code)
    @code = code
  end

  def code
    @code
  end

  def strs=(code)
    ode
    @code_strs = code
  end

  def strs
    @code_strs
  end

  def typo_str
    @typo_str = "Typo. Try again."
  end
end

class Guesser
  include CodeAndColorData
  class << self
    attr_reader :current_guess
  end

  class << self
    attr_writer :current_guess
  end

  def self.play_round(strs)
    push_me = []
    iterate_me = @current_guess.dup
    iterate_me.each_with_index do |el, i|
      if el == strs[i]
        Clue.incr_clue(0)
        push_me.push(el)
      end
    end
    iterate_me.delete_if { |el| push_me.include?(el) }
    iterate_me.uniq.each { |el| Clue.incr_clue(1) if strs.include?(el) }
  end

  def self.play_game(colors, strs, code, typo_str)
    i = 11
    puts "Guess code e.g. 'red orange yellow green'. The CODE WILL NOT REPEAT COLORS, BUT YOU MAY REPEAT COLORS IN YOUR GUESS. A 2-digit clue will show in brackets after each guess — the first digit is the number of colors that are correct and in the right position, and the second digit is the number of colors that are correct but in the wrong position."
    puts colors.values.join ' '
    12.times do
      puts 'Enter next choice.' if i < 11
      Clue.reset_clue
      loop do
        @current_guess = gets.split
        break if @current_guess.all?{|el| colors.keys.map(&:to_s).include?(el)}
        puts typo_str
      end
      Guesser.play_round(strs)
      if Guesser.current_guess == strs
        puts 'Guesser wins!'
        puts code.values.join ' '
        break
      end
      puts "Attempts remaining: #{i}"
      if i >= 1
        p Clue.clue
      else
        puts "Guesser failed. The code was #{code.values.join ' '} ."
      end
      i -= 1
    end
  end
end

class Computer
  include CodeAndColorData
  @current_clue = []
  def self.crack_code(strs, code)
    set = (1111..8888).to_a.delete_if { |el| el.to_s.include?('0') || el.to_s.include?('9') }
    set = set.map(&:to_s).map do |el|
      el.gsub('1', 'red ').gsub('2', 'orange ').gsub('3', 'yellow ').gsub('4', 'green ').gsub('5', 'blue ').gsub('6', 'brown ').gsub('7', 'black ').gsub(
        '8', 'white '
      ).rstrip
    end
    Guesser.current_guess = 'red red orange orange'.split
    i = 11
    12.times do
      sleep(1.5)
      puts "The computer guesses '#{Guesser.current_guess.join ' '}'."
      Clue.reset_clue
      if Guesser.current_guess == strs
        puts 'Computer wins!'
        puts code.values.join ' '
        break
      end
      push_me = []
      Guesser.play_round(strs)
      p Clue.clue
      puts "Attempts remaining: #{i}"
      clue_copy = Clue.clue
      set.each do |el|
        Clue.reset_clue
        code_copy = strs
        strs = el.split
        Guesser.play_round(strs)
        push_me.push(el) if Clue.clue == clue_copy
        strs = code_copy
      end
      set = push_me
      Guesser.current_guess = set[0].split
      i -= 1
    end
  end
end

class Clue
  @clue = [0, 0]

  def self.incr_clue(index)
    @clue[index] += 1
  end

  class << self
    attr_reader :clue
  end

  def self.reset_clue
    @clue = [0, 0]
  end
end

class Game
  include CodeAndColorData
  def choose_side
    loop do
      puts "Do you want to be the code guesser or the code chooser? Enter 'guesser' or 'chooser'."
      @active_player = gets.chomp.downcase
      break if @active_player == 'guesser' || @active_player == 'chooser'
      puts typo_str
    end
  end

  def play_game
    choose_side
    case @active_player
    when 'chooser'
      puts colors.values.join(' ').to_s
      puts "Enter SPACE-SEPARATED, NON-REPEATING sequence (e.g. 'red white blue green')."
      puts "On each turn, the computer will use the 2-digit clue seen in brackets — the first digit is how many colors are correct and in the right position, and the second is how many colors are correct but in the wrong position."
      loop do
        @chosen_code = gets.downcase.split
        break if @chosen_code.uniq.length == 4 && @chosen_code.all?{|el| colors.keys.map(&:to_s).include?(el)}
        puts typo_str
      end
      @chosen_code = @chosen_code.map { |el| [el.to_sym, colors[el]] }.to_h
      code = @chosen_code
      map_code(code)
      Computer.crack_code(strs, code)
    when 'guesser'
      code = shuffle_code
      map_code(code)
      Guesser.play_game(colors, strs, code, typo_str)
    end
  end
end

Game.new.play_game
