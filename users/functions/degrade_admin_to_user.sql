CREATE OR REPLACE FUNCTION "users"."degrade_admin_to_user"(
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
  SELECT "role_uuid"
  INTO "actual_role"
  FROM "users"."user"
  WHERE "user_uuid" = "p_user_uuid";

  IF "actual_role" = 2 THEN
    RETURN FALSE;
  END IF;
  UPDATE "users"."user"
  SET "role_uuid"  = 2,
      "updated_at" = current_timestamp
  WHERE "user_uuid" = "p_user_uuid";
  GET DIAGNOSTICS "affected_rows" = ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
