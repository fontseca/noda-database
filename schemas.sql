/* Schema: addons.  */

CREATE SCHEMA "addons";
COMMENT ON SCHEMA "addons" IS 'database extensions';

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA "addons" TO PUBLIC;
GRANT USAGE ON SCHEMA "addons" TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA "addons"
  GRANT EXECUTE ON FUNCTIONS TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA "addons"
  GRANT USAGE ON TYPES TO PUBLIC;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA "addons" CASCADE;

/* Schema: common.  */

CREATE SCHEMA "common";
COMMENT ON SCHEMA "common" IS 'utility routines and data types';

GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA "common" TO PUBLIC;
GRANT USAGE ON SCHEMA "common" TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA "common"
  GRANT EXECUTE ON ROUTINES TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA "common"
  GRANT USAGE ON TYPES TO PUBLIC;

/* Schema: users.  */

CREATE SCHEMA IF NOT EXISTS "users";
COMMENT ON SCHEMA "users" IS 'user objects';

/* Schema: groups.  */

CREATE SCHEMA IF NOT EXISTS "groups";
COMMENT ON SCHEMA "groups" IS 'group objects';

/* Schema: lists.  */

CREATE SCHEMA IF NOT EXISTS "lists";
COMMENT ON SCHEMA "lists" IS 'list objects';

/* Schema: tasks.  */

CREATE SCHEMA IF NOT EXISTS "tasks";
COMMENT ON SCHEMA "tasks" IS 'task objects';