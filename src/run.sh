#!/bin/bash

read -p 'Название таблицы: ' -r input
if [[ $input =~  \. ]]
then
  IFS='.' read -r -a array <<< "$input"
  table="${array[1]}"
  schema="${array[0]}"
  export table
  export schema
  bash noprompt.sh
else
  export input
  bash prompt.sh
fi