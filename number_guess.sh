#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# query "$($PSQL "")"
# 1 True, 0 False
CHECK_INT () {
  local num
  if [[ -n $1 ]]
  then
  echo -e "$1" >&2 
  fi
  read num
  while ! [[ $num =~ ^[0-9]+$ ]]
  do
    echo -e "That is not an integer, guess again:" >&2 
    read num
  done
  echo "$num"
}

GAME () {
  TRIES=1
  GUESS=$(CHECK_INT "Guess the secret number between 1 and 1000:")
  RANDOM_NUMBER=$((1 + $RANDOM % 1000))
  while [[ "$RANDOM_NUMBER" != "$GUESS" ]]
  do
  if [[ $RANDOM_NUMBER -lt $GUESS ]]
  then
  echo "It's lower than that, guess again:"
  GUESS=$(CHECK_INT)
  (( TRIES++ ))
  else
  echo "It's higher than that, guess again:"
  GUESS=$(CHECK_INT)
  (( TRIES++ ))
  fi
  done
  echo -e "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
  if [[ -z $ID ]]
  then
  ID="$($PSQL "SELECT player_id FROM player WHERE name='$INPUT_NAME'")"
  fi
  INPUTGAME="$($PSQL "INSERT INTO games(tries, player_id) VALUES($TRIES, $ID);")"
}  

echo -e "Enter your username:"
read INPUT_NAME

PLAYER="$($PSQL "SELECT * FROM player WHERE name='$INPUT_NAME';")"
IFS="|" read -r ID NAME <<< $PLAYER

if [[ -z $ID ]]
then

INSERT_NAME="$($PSQL "INSERT INTO player(name) VALUES('$INPUT_NAME');")"

echo -e "Welcome, $INPUT_NAME! It looks like this is your first time here."
GAME

else

OLD_GAMES="$($PSQL "SELECT COUNT(game_id), COALESCE(MIN(tries), 0) FROM games WHERE player_id='$ID';")"
IFS="|" read -r TOTAL_GAMES BEST_GAME <<< "$OLD_GAMES"

echo -e "Welcome back, $NAME! You have played $TOTAL_GAMES games, and your best game took $BEST_GAME guesses."
GAME
fi
