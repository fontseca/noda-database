CREATE OR REPLACE PROCEDURE "users"."assert_exists"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"   INT;
  "user_uuid_txt" TEXT := "p_user_uuid"::TEXT;
BEGIN
  IF "p_user_uuid" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "users"."user"
    WHERE "user_uuid" = "p_user_uuid";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "user_uuid_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent user with UUID "%"', "user_uuid_txt"
    USING HINT = 'Please check the given user UUID.';
END;
$$;
