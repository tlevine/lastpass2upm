#!/bin/sh

lastpasscsv=$(mktemp)
db=$(mktemp)
chmod 600 $lastpasscsv $db

# Passwords file
if [ "$#" = 1 ]; then
  # Read from first argument
  sed 1d "$1" > $lastpasscsv
elif [ ! -t ]; then
  # Read from stdin
  sed 1d /dev/stdin > $lastpasscsv
else
  # Print help
  echo "USAGE: $0 [input file]"
  echo 'You can also use stdin.'
  exit 1
fi

sqlite3 $db << EOF
CREATE TABLE lastpass (
  url TEXT,
  username TEXT,
  password TEXT,
  extra TEXT,
  name TEXT,
  grouping TEXT,
  fav TEXT
);
CREATE VIEW upm AS SELECT
  "name" AS "account name",
  "username" AS "user id",
  "password",
  "url",
  "extra" AS "notes"
FROM lastpass
WHERE grouping != 'Secure Notes';
EOF

sqlite3 -csv $db ".import '$lastpasscsv' lastpass"
sqlite3 $db 'SELECT * FROM upm'

rm $lastpasscsv $db
