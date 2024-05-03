DROP DOMAIN IF EXISTS "common"."pos_t";
CREATE DOMAIN "common"."pos_t" AS INTEGER NOT NULL DEFAULT 1 CHECK (value > 0);
COMMENT ON DOMAIN "common"."pos_t"  IS 'represents a positional value';
