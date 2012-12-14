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
