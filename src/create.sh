psql -h pg -d "$1" -f create.sql -v ON_ERROR_STOP=1