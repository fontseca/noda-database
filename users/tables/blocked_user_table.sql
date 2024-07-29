CREATE TABLE IF NOT EXISTS "users"."blocked_user" AS TABLE "users"."user";

ALTER TABLE "users"."blocked_user"
  ADD COLUMN "reason"     VARCHAR(512) DEFAULT NULL,
  ADD COLUMN "blocked_at" timestamptz NOT NULL DEFAULT current_timestamp,
  ADD COLUMN "blocked_by" uuid REFERENCES "users"."user" ("user_uuid");
