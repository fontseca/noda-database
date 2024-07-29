CREATE TABLE IF NOT EXISTS "attachments"."attachment"
(
  "attachment_uuid" uuid          NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "owner_uuid"    uuid          NOT NULL REFERENCES "users"."user" ("user_uuid"),
  "task_uuid"     uuid          NOT NULL REFERENCES "tasks"."task" ("task_uuid"),
  "file_name"     VARCHAR(255)  NOT NULL,
  "file_url"      VARCHAR(2048) NOT NULL,
  "created_at"    timestamptz   NOT NULL             DEFAULT current_timestamp,
  "updated_at"    timestamptz   NOT NULL             DEFAULT current_timestamp
);

COMMENT ON TABLE "attachments"."attachment"
  IS 'Stores files associated with functions.';
