CREATE TABLE IF NOT EXISTS "tasks"."trashed_task"
AS TABLE "tasks"."task";

ALTER TABLE "tasks"."trashed_task"
  ADD COLUMN IF NOT EXISTS "trashed_at" timestamptz NOT NULL DEFAULT current_timestamp,
  ADD COLUMN IF NOT EXISTS "destroy_at" timestamptz NOT NULL DEFAULT current_timestamp + INTERVAL '7d';
