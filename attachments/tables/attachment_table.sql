CREATE TABLE IF NOT EXISTS "attachments"."attachment"
(
  "attachment_id" uuid          NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "owner_uuid"    uuid          NOT NULL REFERENCES "users"."user" ("user_uuid"),
  "task_id"       uuid          NOT NULL REFERENCES "tasks"."task" ("task_id"),
  "file_name"     VARCHAR(255)  NOT NULL,
  "file_url"      VARCHAR(2048) NOT NULL,
  "created_at"    timestamptz   NOT NULL             DEFAULT now(),
  "updated_at"    timestamptz   NOT NULL             DEFAULT now()
);

COMMENT ON TABLE "attachments"."attachment"
  IS 'Stores files associated with functions.';
