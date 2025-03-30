#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# query "$($PSQL "")"

echo -e "\nEnter your username:"
read INPUT_NAME

PLAYER="$($PSQL "SELECT * FROM player WHERE name='$INPUT_NAME';")"
IFS="|" read -r ID NAME <<< $PLAYER

if [[ -z $PLAYER ]]
then

INSERT_NAME="$($PSQL "INSERT INTO player(name) VALUES('$INPUT_NAME');")"

echo -e "\nWelcome, $INPUT_NAME! It looks like this is your first time here.\n"

else

OLD_GAMES="$($PSQL "SELECT COUNT(game_id), MIN(tries) FROM games WHERE player_id='$ID';")"
IFS="|" read -r TOTAL_GAMES BEST_GAME <<< "$OLD_GAMES"

echo -e "\nWelcome back, $NAME! You have played $TOTAL_GAMES games, and your best game took $BEST_GAME guesses.\n"

fi

GAME () {
  echo "what is this"
}  
