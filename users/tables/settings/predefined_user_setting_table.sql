CREATE TABLE IF NOT EXISTS "users"."predefined_setting"
(
  "key"           VARCHAR(64) PRIMARY KEY,
  "default_value" json         NULL,
  "description"   VARCHAR(512) NULL
);

COMMENT ON TABLE "users"."predefined_setting"
  IS 'default user-specific settings';
