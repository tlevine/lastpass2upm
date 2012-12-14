#!/bin/sh

lastpasscsv=$(mktemp)
db=$(mktemp)
chmod 600 $lastpasscsv $db

# Passwords file
if [ "$#" = 1 ]; then
  sed 1d "$1" > $lastpasscsv
else
  sed 1d /dev/stdin > $lastpasscsv
fi

sqlite3 $db < schema.sql
sqlite3 -csv $db ".import '$lastpasscsv' lastpass"
sqlite3 $db 'SELECT * FROM upm'

rm $lastpasscsv $db
