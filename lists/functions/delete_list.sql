CREATE OR REPLACE FUNCTION "lists"."delete"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_id" "lists"."list"."group_uuid"%TYPE,
  IN "p_list_id" "lists"."list"."list_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows"            INT;
  "is_scattered_list" CONSTANT BOOLEAN := "p_group_id" IS NULL;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_is_not_special_list"("p_owner_id", "p_list_id");
  CALL "lists"."assert_exists"("p_owner_id", "p_group_id", "p_list_id");
  DELETE
  FROM "lists"."list"
  WHERE "owner_uuid" = "p_owner_id"
    AND CASE
          WHEN "is_scattered_list"
            THEN "group_uuid" IS NULL
          ELSE "group_uuid" = "p_group_id"
    END
    AND "list_uuid" = "p_list_id";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
