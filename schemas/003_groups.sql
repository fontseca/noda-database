CREATE SCHEMA IF NOT EXISTS "groups";
COMMENT ON SCHEMA "groups" IS 'schema for group related objects';

CREATE USER "dml_groups" WITH ENCRYPTED PASSWORD 'secret';
ALTER SCHEMA "groups" OWNER TO "dml_groups";

GRANT CONNECT ON DATABASE "noda" TO "dml_groups";
GRANT REFERENCES ON ALL TABLES IN SCHEMA "users" TO "dml_groups";
GRANT USAGE ON SCHEMA "users" TO "dml_groups";

ALTER ROLE "dml_groups" SET search_path = "public", "groups";
