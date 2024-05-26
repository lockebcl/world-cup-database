#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]] 
  then
    # get teamID
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

    if [[ -z $TEAM_ID_WINNER ]]
    then
      #insert team
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_OPPONENT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
    
  
  

  fi
  echo -e "\n"
  # ADD GAMES
  if [[ YEAR != 'year' ]]
  then
    #WINNER_ID  
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # Opponent ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo $WINNER VS $OPPONENT game Added!
      fi
  
  fi



done