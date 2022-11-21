plan:


game class (has game status, guesses remaining, a loop that plays each round)

guesser class

creator class (has code)

board class (has codes entered with clue for each.)


1. player enters code (assume correct digits entered for now).
2. the game does the following:
  A) checks if any of those digits are both correct and correctly placed. 
    
    ["red","green","blue"].each_with_index {|el, i| puts el if el == Creator.code.keys[i].to_s}
  
  
  
  
  if this is the case, increment the respective clue digit by 1. do this looping thru each of the player's digits.
  B) checks if any player digits ASIDE FROM THE ONES JUST DETAILED IN STEP A are included in the digits of the code that were NOT verified in step A. loop thru these remaining digits, incrementing the second clue digit by 1 with each iteration.
   
   are the all and any methods useful here?
  
  As this is happening, the board updates accordingly, displaying strings in rows. I guess the clue object will be part of the board object?. If the guesser doesn't get the code right within 12 turns, then they lose.
3.


"Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or the guesser."

1. program prompts user if they want to be the code creator or the code guesser.
  A) If the user chooses guesser, use Guesser.play_game
  B) If the user chooses creator, user Creator.play_game


Computer guess pseudocode:
create set of numbers 1111..8888
set = (1111..8888).to_a.delete_if {|el| el.to_s.include?("0") || el.to_s.include?("9")}

start with 1122

loop: if guess == code, break & win
      else,
      1) play round for each set item and filter those that produce the same clue.
      2) pick first element in set and use it for the guess.


<!-- 1) computer guesses "red red orange orange" on first try. use counter to determine if first turn?
  possible clues and choices:
  [0, 0]
    then guess yellow yellow green green
      [0, 0]

  [2, 0]
    then ans would be [r r o o], and a blank would be needed, so ------- yellow yellow green green
  [1, 0]
    one is correct, other is wrong. first, computer would try 
    the following to check which color is correct:
    ---------- red red red red
  [1, 1]
    one is correctly placed, other is correct but misplaced. a blank would be needed, so:
    ---------- yellow yellow green green
  [0, 1]
    only one is even present, but blank is provided. computer finds which is present, so:
    ---------- red red red red
  [0, 2]
    this means the correct placement would be [o o r r]. a blank would be needed, so
    ---------- yellow yellow green green -->