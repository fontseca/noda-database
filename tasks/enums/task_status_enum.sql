DROP TYPE IF EXISTS "tasks"."task_status_t";

CREATE TYPE "tasks"."task_status_t"
AS ENUM ('finished',
  'in progress',
  'unfinished',
  'decayed');


COMMENT ON TYPE "tasks"."task_status_t"
  IS 'Represents the different status levels that a task can have within the system.';
