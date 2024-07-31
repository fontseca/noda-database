CREATE OR REPLACE PROCEDURE "lists"."assert_exists_somewhere"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"   INT;
  "list_uuid_txt" TEXT := "p_list_uuid"::TEXT;
BEGIN
  IF "p_list_uuid" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "lists"."list"
    WHERE "owner_uuid" = "p_owner_id"
      AND "list_uuid" = "p_list_uuid";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "list_uuid_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent list with UUID "%"', "list_uuid_txt"
    USING HINT = 'Please check the given list UUID.';
END;
$$;
