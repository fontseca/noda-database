CREATE TABLE IF NOT EXISTS "groups"."group"
(
  "group_uuid"  uuid        NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "owner_uuid"  uuid        NOT NULL REFERENCES "users"."user" ("user_uuid") ON DELETE CASCADE,
  "name"        VARCHAR(64) NOT NULL CHECK ("name" <> ''),
  "description" VARCHAR(512)                     DEFAULT NULL,
  "created_at"  timestamptz NOT NULL             DEFAULT current_timestamp,
  "updated_at"  timestamptz NOT NULL             DEFAULT current_timestamp
);

COMMENT ON TABLE "groups"."group"
  IS 'gathers together lists';
