CREATE TABLE IF NOT EXISTS "tasks"."task"
(
  "task_uuid"        uuid PRIMARY KEY          NOT NULL DEFAULT "addons"."uuid_generate_v4"(),
  "owner_uuid"       uuid                      NOT NULL REFERENCES "users"."user" ("user_uuid") ON DELETE CASCADE,
  "list_uuid"        uuid                      NOT NULL REFERENCES "lists"."list" ("list_uuid") ON DELETE CASCADE,
  "position_in_list" "common"."pos_t"          NOT NULL,
  "title"            VARCHAR(128)              NOT NULL,
  "headline"         VARCHAR(64)                        DEFAULT NULL,
  "description"      VARCHAR(512)                       DEFAULT NULL,
  "priority"         "tasks"."task_priority_t" NOT NULL,
  "status"           "tasks"."task_status_t"   NOT NULL,
  "is_pinned"        BOOLEAN                   NOT NULL DEFAULT FALSE,
  "due_date"         timestamptz                        DEFAULT NULL,
  "remind_at"        timestamptz                        DEFAULT NULL,
  "completed_at"     timestamptz                        DEFAULT NULL,
  "created_at"       timestamptz               NOT NULL DEFAULT current_timestamp,
  "updated_at"       timestamptz               NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE "tasks"."task"
  IS 'Manages individual functions, including titles, descriptions, statuses, etc.';
