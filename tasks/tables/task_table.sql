CREATE TABLE IF NOT EXISTS "task"
(
  "task_id"          UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4 (),
  "owner_uuid"         UUID NOT NULL REFERENCES"users"."user" ("user_uuid"),
  "list_uuid"          UUID NOT NULL REFERENCES "lists"."list" ("list_uuid") ON DELETE CASCADE,
  "position_in_list" pos_t NOT NULL,
  "title"            VARCHAR(128) NOT NULL,
  "headline"         VARCHAR(64) DEFAULT NULL,
  "description"      VARCHAR(512) DEFAULT NULL,
  "priority"         task_priority_t NOT NULL,
  "status"           task_status_t NOT NULL,
  "is_pinned"        BOOLEAN NOT NULL DEFAULT FALSE,
  "due_date"         TIMESTAMPTZ DEFAULT NULL,
  "remind_at"        TIMESTAMPTZ DEFAULT NULL,
  "completed_at"     TIMESTAMPTZ DEFAULT NULL,
  "created_at"       TIMESTAMPTZ NOT NULL DEFAULT now (),
  "updated_at"       TIMESTAMPTZ NOT NULL DEFAULT now ()
);

ALTER TABLE "task"
   OWNER TO "noda";

COMMENT ON TABLE "task"
              IS 'Manages individual functions, including titles, descriptions, statuses, etc.';
