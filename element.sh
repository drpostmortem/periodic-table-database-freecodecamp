#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check input
if [[ -z "$1" ]]
then
  # if no valid input, return error message
  echo "Please provide an element as an argument."
else
  # if valid input, get data from tables 
  MATCH=$($PSQL "select * from elements where atomic_number::text='$1' or symbol='$1' or name='$1' ;")
  if [[ -z $MATCH ]]
  then 
    echo "I could not find that element in the database."
  else 
    ATOMIC_NUMBER=$(echo $MATCH | cut -d '|' -f 1)
    SYMBOL=$(echo $MATCH | cut -d '|' -f 2)
    NAME=$(echo $MATCH | cut -d '|' -f 3)
    
    
    PROPERTIES=$($PSQL "select type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER ;")
    TYPE=$(echo $PROPERTIES | cut -d '|' -f 1)
    ATOMIC_MASS=$(echo $PROPERTIES | cut -d '|' -f 2)
    MELTING_POINT=$(echo $PROPERTIES | cut -d '|' -f 3)
    BOILING_POINT=$(echo $PROPERTIES | cut -d '|' -f 4)
    
    # return output message
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi

# comment1
# comment2
# comment3
