CREATE DOMAIN "common"."email_t"
  AS VARCHAR(240) NOT NULL
  CHECK (value ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

COMMENT ON DOMAIN "common"."email_t"
  IS 'ensures a string has a valid email format';
