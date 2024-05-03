CREATE SCHEMA IF NOT EXISTS "lists";
COMMENT ON SCHEMA "lists" IS 'schema for list related objects';

CREATE USER "dml_lists" WITH ENCRYPTED PASSWORD 'secret';
ALTER SCHEMA "lists" OWNER TO "dml_lists";

GRANT CONNECT ON DATABASE "noda" TO "dml_lists";
GRANT REFERENCES ON ALL TABLES IN SCHEMA "users" TO "dml_lists";
GRANT USAGE ON SCHEMA "users" TO "dml_lists";
GRANT REFERENCES ON ALL TABLES IN SCHEMA "groups" TO "dml_lists";
GRANT USAGE ON SCHEMA "groups" TO "dml_lists";

ALTER ROLE "dml_lists" SET search_path = "public", "lists";