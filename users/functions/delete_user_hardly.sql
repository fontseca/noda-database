CREATE OR REPLACE FUNCTION "users"."delete_hardly"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows" INT;
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  DELETE
  FROM "users"."user"
  WHERE "user_uuid" = "p_user_uuid";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
