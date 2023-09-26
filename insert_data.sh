#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[$YEAR != "year"]]
  then
    WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE team=$WINNER")
    if [[-z $WINNER_TEAM]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(team) VALUES($WINNER)")
    fi
    OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE team=$OPPONENT")
    if [[-z $OPPONENT_TEAM]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(team) VALUES($OPPONENT)")
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE team=$WINNER")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE team=$OPPONENT")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
  
done
