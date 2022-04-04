#!/bin/bash
set -e

read -p 'Название базы данных: ' -r db

# create functions
bash create.sh "$db"

read -p 'Название таблицы: ' -r input

IFS='.' read -r -a array <<<"$input"

res="${input//[^\.]/}"
if [[ "${#res}" == "2" ]]; then
  echo "2"
  table="${array[2]}"
  schema="${array[1]}"
  db_="${array[0]}"
  if [ "$db" != "$db_" ]; then
    echo "Database names don't match, exiting"
    exit
  fi
  export table
  export schema
  bash noprompt.sh "$db" "$schema" "$table"
elif [[ "${#res}" == "1" ]]; then
  echo "1"
  table="${array[1]}"
  schema="${array[0]}"
  export table
  export schema
  bash noprompt.sh "$db"
elif [[ "${#res}" == "0" ]]; then
  echo "0"
  export input
  bash prompt.sh "$db"
else
  echo "Wrong format of input"
fi