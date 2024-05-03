CREATE SCHEMA IF NOT EXISTS "tasks";
COMMENT ON SCHEMA "tasks" IS 'schema for task related objects';

CREATE USER "dml_tasks" WITH ENCRYPTED PASSWORD 'secret';
ALTER SCHEMA "tasks" OWNER TO "dml_tasks";

GRANT CONNECT ON DATABASE "noda" TO "dml_tasks";

ALTER ROLE "dml_tasks" SET search_path = "public", "tasks";
