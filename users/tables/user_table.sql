CREATE TABLE IF NOT EXISTS "users"."user"
(
  "user_uuid"   uuid        NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "role_uuid"   SMALLINT    NOT NULL REFERENCES "users"."role" ("uuid"),
  "first_name"  VARCHAR(64) NOT NULL CHECK ("first_name" <> ''),
  "middle_name" VARCHAR(64)                      DEFAULT NULL,
  "last_name"   VARCHAR(64)                      DEFAULT NULL,
  "surname"     VARCHAR(64)                      DEFAULT NULL,
  "picture_url" VARCHAR(2048)                    DEFAULT NULL,
  "email"       "common"."email_t" UNIQUE,
  "password"    TEXT        NOT NULL CHECK ("password" <> ''),
  "created_at"  timestamptz NOT NULL             DEFAULT current_timestamp,
  "updated_at"  timestamptz NOT NULL             DEFAULT current_timestamp
);

COMMENT ON TABLE "users"."user"
  IS 'system user with personal information and account details';
