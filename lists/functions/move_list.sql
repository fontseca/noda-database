CREATE OR REPLACE FUNCTION "lists"."move"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE,
  IN "p_dst_group_uuid" "lists"."list"."group_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "current_group_uuid" "lists"."list"."group_uuid"%TYPE;
  "n_affected_rows"  INT;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_uuid");
  CALL "groups"."assert_exists"("p_owner_id", "p_dst_group_uuid");
  SELECT "l"."group_uuid"
  INTO "current_group_uuid"
  FROM "lists"."list" "l"
  WHERE "l"."owner_uuid" = "p_owner_id"
    AND "l"."list_uuid" = "p_list_uuid";
  IF "current_group_uuid" = "p_dst_group_uuid" THEN
    RETURN FALSE;
  END IF;
  UPDATE "lists"."list"
  SET "group_uuid" = "p_dst_group_uuid",
      "updated_at" = current_timestamp
  WHERE "owner_uuid" = "p_owner_id"
    AND "list_uuid" = "p_list_uuid";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
