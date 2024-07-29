DROP TYPE IF EXISTS "tasks"."task_update_t";

CREATE TYPE "tasks"."task_update_t" AS
(
  "title"       VARCHAR(128),
  "headline"    VARCHAR(64),
  "description" VARCHAR(512)
);

COMMENT ON TYPE "tasks"."task_update_t"
  IS 'Represents the specifications for updating a task.';
