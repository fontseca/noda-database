DROP TYPE IF EXISTS "tasks"."task_priority_t";

CREATE TYPE "tasks"."task_priority_t"
AS ENUM ('urgent',
  'high',
  'medium',
  'normal',
  'low');

COMMENT ON TYPE "tasks"."task_priority_t"
  IS 'Defines the priority levels that can be assigned to functions.';
