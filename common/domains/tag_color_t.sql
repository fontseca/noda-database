DROP DOMAIN IF EXISTS "common"."tag_color_t";

CREATE DOMAIN "common"."tag_color_t"
  AS VARCHAR NOT NULL
  CHECK (value ~ '^([A-F0-9]{6})$' AND LENGTH (value) = 6);

COMMENT ON DOMAIN common."tag_color_t"
  IS 'hexadecimal number used to define valid colors which does not require the #';

