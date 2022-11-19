plan:


game class (has game status, guesses remaining, a loop that plays each round)

guesser class

creator class (has code)

board class (has codes entered with clue for each.)


1. player enters code (assume correct digits entered for now).
2. the game does the following:
  A) checks if any of those digits is both correct and correctly placed. if this is the case, increment the respective clue digit by 1. do this looping thru each of the player's digits.
  B) checks if any player digits ASIDE FROM THE ONES JUST DETAILED IN STEP A are included in the digits of the code that were NOT verified in step A. loop thru these remaining digits, incrementing the second clue digit by 1 with each iteration.
   
   are the all and any methods useful here?
  
  As this is happening, the board updates accordingly, displaying strings in rows. I guess the clue object will be part of the board object?. If the guesser doesn't get the code right within 12 turns, then they lose.
3. 