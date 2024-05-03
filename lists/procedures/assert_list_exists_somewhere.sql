CREATE OR REPLACE PROCEDURE "lists"."assert_list_exists_somewhere"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_id" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"   INT;
  "list_id_txt" TEXT := "p_list_id"::TEXT;
BEGIN
  IF "p_list_id" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "lists"."list"
    WHERE "owner_uuid" = "p_owner_id"
      AND "list_uuid" = "p_list_id";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "list_id_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent list with ID "%"', "list_id_txt"
    USING HINT = 'Please check the given list ID.';
END;
$$;
