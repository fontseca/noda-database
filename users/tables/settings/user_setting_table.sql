CREATE TABLE IF NOT EXISTS "users"."setting"
(
  "user_setting_uuid" uuid PRIMARY KEY     DEFAULT "addons"."uuid_generate_v4"(),
  "user_uuid"         uuid        NOT NULL REFERENCES "users"."user" ("user_uuid") ON DELETE CASCADE,
  "key"               VARCHAR(50) NOT NULL REFERENCES "users"."predefined_setting" ("key") ON DELETE CASCADE,
  "value"             json        NOT NULL,
  "created_at"        timestamptz NOT NULL DEFAULT current_timestamp,
  "updated_at"        timestamptz NOT NULL DEFAULT current_timestamp
);

COMMENT ON TABLE "users"."setting"
  IS 'user-specific settings stored as key-value pairs';
