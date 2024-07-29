CREATE OR REPLACE FUNCTION "lists"."update"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_id" "lists"."list"."group_uuid"%TYPE,
  IN "p_list_id" "lists"."list"."list_uuid"%TYPE,
  IN "p_l_name" "lists"."list"."name"%TYPE,
  IN "p_l_desc" "lists"."list"."description"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows"            INT;
  "old_l_name"                 "lists"."list"."name"%TYPE;
  "old_l_desc"                 "lists"."list"."description"%TYPE;
  "is_scattered_list" CONSTANT BOOLEAN := "p_group_id" IS NULL;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_is_not_special_list"("p_owner_id", "p_list_id");
  CALL "lists"."assert_exists"("p_owner_id", "p_group_id", "p_list_id");
  SELECT "l"."name",
         "l"."description"
  INTO "old_l_name",
    "old_l_desc"
  FROM "lists"."list" "l"
  WHERE "l"."owner_uuid" = "p_owner_id"
    AND CASE
          WHEN "is_scattered_list"
            THEN TRUE
          ELSE "group_uuid" = "p_group_id"
    END
    AND "l"."list_uuid" = "p_list_id";
  "p_l_name" := nullif(trim(BOTH ' ' FROM "p_l_name"), '');
  "p_l_desc" := trim(BOTH ' ' FROM "p_l_desc");
  IF ("p_l_name" IS NULL OR "old_l_name" = "p_l_name") AND
     ("p_l_desc" IS NULL OR "old_l_desc" = "p_l_desc")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "lists"."list"
  SET "name"        = coalesce("p_l_name", "old_l_name"),
      "description" = coalesce("p_l_desc", "old_l_desc"),
      "updated_at"  = current_timestamp
  WHERE "owner_uuid" = "p_owner_id"
    AND CASE
          WHEN "is_scattered_list"
            THEN "group_uuid" IS NULL
          ELSE "group_uuid" = "p_group_id"
    END
    AND "list_uuid" = "p_list_id";
  GET DIAGNOSTICS "n_affected_rows" = ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
