CREATE OR REPLACE PROCEDURE "lists"."assert_exists"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_id" "lists"."list"."group_uuid"%TYPE,
  IN "p_list_id" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"                INT;
  "list_id_txt"              TEXT    := "p_list_id"::TEXT;
  "is_grouped_list" CONSTANT BOOLEAN := "p_group_id" IS NOT NULL;
  "hint"                     TEXT    := 'Please check the given list ID.';
BEGIN
  IF "is_grouped_list" THEN
    CALL "groups"."assert_exists"("p_owner_id", "p_group_id");
  END IF;
  IF "p_list_id" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "lists"."list"
    WHERE "owner_uuid" = "p_owner_id"
      AND CASE
            WHEN "is_grouped_list"
              THEN "group_uuid" = "p_group_id"
            ELSE "group_uuid" IS NULL
      END
      AND "list_uuid" = "p_list_id";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "list_id_txt" := '(NULL)';
  END IF;
  IF NOT "is_grouped_list" THEN
    "hint" := 'Please check the given list ID or whether the list is scattered.';
  END IF;
  RAISE EXCEPTION 'nonexistent list with ID "%"', "list_id_txt"
    USING HINT = "hint";
END;
$$;
