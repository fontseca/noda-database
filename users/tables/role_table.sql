CREATE TABLE IF NOT EXISTS "users"."role"
(
  "id"   SMALLINT    NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  "name" VARCHAR(64) NOT NULL CHECK ("name" <> '')
);

COMMENT ON TABLE "users"."role"
  IS 'a role for a user';
