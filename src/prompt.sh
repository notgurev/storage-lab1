psql -h pg -d "$1" -f prompt.sql -t -v ON_ERROR_STOP=1 2>&1 | sed 's|.*NOTICE:  ||g'