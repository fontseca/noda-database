CREATE TABLE IF NOT EXISTS "tasks"."step"
(
  "step_uuid"    uuid PRIMARY KEY NOT NULL DEFAULT "addons"."uuid_generate_v4"(),
  "task_uuid"    uuid             NOT NULL REFERENCES "tasks"."task" ("task_id"),
  "order"        "common"."pos_t" NOT NULL UNIQUE,
  "description"  VARCHAR(512)              DEFAULT NULL,
  "completed_at" timestamptz               DEFAULT NULL,
  "created_at"   timestamptz      NOT NULL DEFAULT current_timestamp,
  "updated_at"   timestamptz      NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE "tasks"."step"
  IS 'Logical steps to follow to complete a task.';
