CREATE SCHEMA IF NOT EXISTS "users";
COMMENT ON SCHEMA "users" IS 'schema for user related objects';

CREATE USER "dml_users" WITH ENCRYPTED PASSWORD 'secret';
ALTER SCHEMA "users" OWNER TO "dml_users";

GRANT CONNECT ON DATABASE "noda" TO "dml_users";

ALTER ROLE "dml_users" SET search_path = "public", "users";
