CREATE OR REPLACE FUNCTION "users"."promote_to_admin"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
  "actual_role"   INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  SELECT "role_id"
  INTO "actual_role"
  FROM "users"."user"
  WHERE "user_uuid" = "p_user_uuid";
  IF "actual_role" = 1 THEN
    RETURN FALSE;
  END IF;
  UPDATE "users"."user"
  SET "role_id"  = 1,
      "updated_at" = current_timestamp
  WHERE "user_uuid" = "p_user_uuid";
  GET DIAGNOSTICS "affected_rows" = ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
