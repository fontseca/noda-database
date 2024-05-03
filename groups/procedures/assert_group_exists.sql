CREATE OR REPLACE PROCEDURE "groups"."assert_exists"(
  IN "p_owner_id" "groups"."group"."owner_uuid"%TYPE,
  IN "p_group_id" "groups"."group"."group_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"    INT;
  "group_id_txt" TEXT := "p_group_id"::TEXT;
BEGIN
  IF "p_group_id" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "groups"."group"
    WHERE "owner_uuid" = "p_owner_id"
      AND "group_uuid" = "p_group_id";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "group_id_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent group with ID "%"', "group_id_txt"
    USING HINT = 'Please check the given group ID.';
END;
$$;
