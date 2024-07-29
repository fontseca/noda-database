CREATE TABLE IF NOT EXISTS "users"."user"
(
  "user_uuid"   uuid        NOT NULL PRIMARY KEY DEFAULT "addons"."uuid_generate_v4"(),
  "role_id"     SMALLINT    NOT NULL REFERENCES "users"."role" ("id"),
  "first_name"  VARCHAR(64) NOT NULL CHECK ("first_name" <> ''),
  "middle_name" VARCHAR(64)                      DEFAULT NULL,
  "last_name"   VARCHAR(64)                      DEFAULT NULL,
  "surname"     VARCHAR(64)                      DEFAULT NULL,
  "picture_url" VARCHAR(2048)                    DEFAULT NULL,
  "email"       "common"."email_t" UNIQUE,
  "password"    bytea       NOT NULL CHECK ("password" <> ''::bytea),
  "created_at"  timestamptz NOT NULL             DEFAULT current_timestamp,
  "updated_at"  timestamptz NOT NULL             DEFAULT current_timestamp
);

COMMENT ON TABLE "users"."user"
  IS 'system user with personal information and account details';
