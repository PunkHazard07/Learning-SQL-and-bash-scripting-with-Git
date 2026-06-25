#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

  ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else

ATOMIC_NUMBER=$(echo $ELEMENT_INFO | sed -E 's/ *\| */|/g' | cut -d'|' -f1)
SYMBOL=$(echo $ELEMENT_INFO | sed -E 's/ *\| */|/g' | cut -d'|' -f2)
NAME=$(echo $ELEMENT_INFO | sed -E 's/ *\| */|/g' | cut -d'|' -f3)

PROPERTIES=$($PSQL "SELECT t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM properties p JOIN types t ON p.type_id = t.type_id WHERE p.atomic_number = $ATOMIC_NUMBER")
TYPE=$(echo $PROPERTIES | sed -E 's/ *\| */|/g' | cut -d'|' -f1)
    MASS=$(echo $PROPERTIES | sed -E 's/ *\| */|/g' | cut -d'|' -f2)
    MELTING_POINT=$(echo $PROPERTIES | sed -E 's/ *\| */|/g' | cut -d'|' -f3)
    BOILING_POINT=$(echo $PROPERTIES | sed -E 's/ *\| */|/g' | cut -d'|' -f4)

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
