#!/bin/bash
set -e

while [ "$db" == "" ]; do
  read -p 'Название базы данных: ' -r db
  if [ "$db" == "" ]; then
    echo "Вы ввели пустую строку. Введите корректное значение!"
  fi
done

# create functions
bash create.sh "$db"

while [ "$input" == "" ]; do
  read -p 'Название таблицы: ' -r input
  if [ "$input" == "" ]; then
    echo "Вы ввели пустую строку. Введите корректное значение!"
  fi
done

IFS='.' read -r -a array <<<"$input"
res="${input//[^\.]/}"

if [[ "${#res}" == "2" ]]; then
  table="${array[2]}"
  schema="${array[1]}"
  db_="${array[0]}"
  if [ "$db" != "$db_" ]; then
    echo "Ошибка: названия баз данных не совпадают, завершение работы..."
    exit
  fi
  export table
  export schema
  bash noprompt.sh "$db" "$schema" "$table"
elif [[ "${#res}" == "1" ]]; then
  table="${array[1]}"
  schema="${array[0]}"
  export table
  export schema
  bash noprompt.sh "$db"
elif [[ "${#res}" == "0" ]]; then
  export input
  bash prompt.sh "$db"
else
  echo "Ошибка: некорректный формат названия таблицы, завершение работы..."
fi
