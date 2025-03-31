#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "Enter your username:"
read INPUT_NAME

PLAYER="$($PSQL "SELECT * FROM player WHERE name='$INPUT_NAME';")"
IFS="|" read -r ID NAME <<< $PLAYER

if [[ -z $ID ]]
then

INSERT_NAME="$($PSQL "INSERT INTO player(name) VALUES('$INPUT_NAME');")"

echo -e "Welcome, $INPUT_NAME! It looks like this is your first time here."

else

OLD_GAMES="$($PSQL "SELECT COUNT(game_id), COALESCE(MIN(tries), 0) FROM games WHERE player_id='$ID';")"
IFS="|" read -r TOTAL_GAMES BEST_GAME <<< "$OLD_GAMES"

echo "Welcome back, $NAME! You have played $TOTAL_GAMES games, and your best game took $BEST_GAME guesses."
fi

echo "Guess the secret number between 1 and 1000:"
TRIES=1
  GUESS=""
  RANDOM_NUMBER=$((1 + $RANDOM % 1000))
  while [[ "$RANDOM_NUMBER" != "$GUESS" ]]
  do
  read GUESS
  if [[ $GUESS =~ ^[0-9]+$  ]]
  then
    if [[ $RANDOM_NUMBER -lt $GUESS ]]
    then
      echo "It's lower than that, guess again:"
      (( ++TRIES ))
    elif [[ $RANDOM_NUMBER -gt $GUESS ]]
    then
      echo "It's higher than that, guess again:"
      (( ++TRIES ))
    fi
  else 
    echo "That is not an integer, guess again: "
  fi
  done
  if [[ -z $ID ]]
  then
  ID="$($PSQL "SELECT player_id FROM player WHERE name='$INPUT_NAME'")"
  fi
  INPUTGAME="$($PSQL "INSERT INTO games(tries, player_id) VALUES($TRIES, $ID);")"
  echo You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!
