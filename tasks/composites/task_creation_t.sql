DROP TYPE IF EXISTS "tasks"."task_creation_t";

CREATE TYPE "tasks"."task_creation_t" AS
(
  "title"       VARCHAR(128),
  "headline"    VARCHAR(64),
  "description" VARCHAR(512),
  "priority"    "tasks"."task_priority_t",
  "status"      "tasks"."task_status_t",
  "due_date"    timestamptz,
  "remind_at"   timestamptz
);

COMMENT ON TYPE "tasks"."task_creation_t"
  IS 'Represents the specifications for creating a new task.';
