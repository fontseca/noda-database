CREATE OR REPLACE FUNCTION "users"."update_setting_of"(
  IN "p_user_id" "users"."user"."user_uuid"%TYPE,
  IN "p_user_setting_key" "users"."setting"."key"%TYPE,
  IN "p_user_setting_val" "users"."setting"."value"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "actual_setting_val" TEXT;
  "affected_rows"      INT;
BEGIN
  CALL "users"."assert_exists"("p_user_id");
  CALL "users"."assert_predefined_setting_exists"("p_user_setting_key");
  SELECT "value"
  INTO "actual_setting_val"
  FROM "users"."setting"
  WHERE "user_uuid" = "p_user_id"
    AND "key" = "p_user_setting_key";
  IF "p_user_setting_val"::TEXT = "actual_setting_val"::TEXT THEN
    RETURN FALSE;
  END IF;
  UPDATE "users"."setting"
  SET "value"      = "p_user_setting_val",
      "updated_at" = current_timestamp
  WHERE "user_uuid" = "p_user_id"
    AND "key" = "p_user_setting_key";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RAISE NOTICE 'count is %', "affected_rows";
  RETURN "affected_rows";
END;
$$;
