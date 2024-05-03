CREATE OR REPLACE PROCEDURE "users"."assert_exists"(
  IN "p_user_id" "users"."user"."user_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"   INT;
  "user_id_txt" TEXT := "p_user_id"::TEXT;
BEGIN
  IF "p_user_id" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "users"."user"
    WHERE "user_uuid" = "p_user_id";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "user_id_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent user with ID "%"', "user_id_txt"
    USING HINT = 'Please check the given user ID.';
END;
$$;
