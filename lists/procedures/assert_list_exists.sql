CREATE OR REPLACE PROCEDURE "lists"."assert_exists"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_uuid" "lists"."list"."group_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"                INT;
  "list_uuid_txt"              TEXT    := "p_list_uuid"::TEXT;
  "is_grouped_list" CONSTANT BOOLEAN := "p_group_uuid" IS NOT NULL;
  "hint"                     TEXT    := 'Please check the given list UUID.';
BEGIN
  IF "is_grouped_list" THEN
    CALL "groups"."assert_exists"("p_owner_id", "p_group_uuid");
  END IF;
  IF "p_list_uuid" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "lists"."list"
    WHERE "owner_uuid" = "p_owner_id"
      AND CASE
            WHEN "is_grouped_list"
              THEN "group_uuid" = "p_group_uuid"
            ELSE "group_uuid" IS NULL
      END
      AND "list_uuid" = "p_list_uuid";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "list_uuid_txt" := '(NULL)';
  END IF;
  IF NOT "is_grouped_list" THEN
    "hint" := 'Please check the given list UUID or whether the list is scattered.';
  END IF;
  RAISE EXCEPTION 'nonexistent list with UUID "%"', "list_uuid_txt"
    USING HINT = "hint";
END;
$$;
