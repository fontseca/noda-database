CREATE TABLE IF NOT EXISTS "tasks"."tag"
(
  "tag_uuid"    uuid                   NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "owner_uuid"  uuid                   NOT NULL REFERENCES "users"."user" ("user_uuid") ON DELETE CASCADE,
  "name"        VARCHAR(50)            NOT NULL,
  "description" VARCHAR(512)                                DEFAULT NULL,
  "color"       "common"."tag_color_t" NOT NULL             DEFAULT 'FFF',
  "created_at"  timestamptz            NOT NULL             DEFAULT current_timestamp,
  "updated_at"  timestamptz            NOT NULL             DEFAULT current_timestamp
);

COMMENT ON TABLE "tasks"."tag"
  IS 'labels and categorizes enhance organization and searchability';
