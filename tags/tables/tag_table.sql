CREATE TABLE IF NOT EXISTS "tag"
(
  "tag_id"      UUID NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4 (),
  "owner_uuid"    UUID NOT NULL REFERENCES"users"."user" ("user_uuid"),
  "name"        VARCHAR(50) NOT NULL UNIQUE,
  "description" VARCHAR(512) DEFAULT NULL,
  "color"       tag_color_t NOT NULL DEFAULT 'fff',
  "created_at"  TIMESTAMPTZ NOT NULL DEFAULT now (),
  "updated_at"  TIMESTAMPTZ NOT NULL DEFAULT now ()
);

ALTER TABLE "tag"
   OWNER TO "noda";

COMMENT ON TABLE "tag"
              IS 'Labels and categorizes enhance organization and searchability.';
