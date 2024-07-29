CREATE OR REPLACE FUNCTION "groups"."update"(
  IN "p_owner_id" "groups"."group"."owner_uuid"%TYPE,
  IN "p_group_uuid" "groups"."group"."group_uuid"%TYPE,
  IN "p_g_name" "groups"."group"."name"%TYPE,
  IN "p_g_desc" "groups"."group"."description"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows" INT;
  "old_g_name"      "groups"."group"."name"%TYPE;
  "old_g_desc"      "groups"."group"."description"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "groups"."assert_exists"("p_owner_id", "p_group_uuid");
  SELECT "g"."name",
         "g"."description"
  INTO "old_g_name",
    "old_g_desc"
  FROM "groups"."group" "g"
  WHERE "g"."group_uuid" = "p_group_uuid"
    AND "g"."owner_uuid" = "p_owner_id";
  "p_g_name" := trim(BOTH ' ' FROM "p_g_name");
  "p_g_desc" := trim(BOTH ' ' FROM "p_g_desc");
  IF ("old_g_name" = "p_g_name" OR "p_g_name" = '' OR "p_g_name" IS NULL) AND
     ("old_g_desc" = "p_g_desc" OR "p_g_desc" = '' OR "p_g_desc" IS NULL)
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "groups"."group"
  SET "name"        = coalesce(nullif("p_g_name", ''), "old_g_name"),
      "description" = coalesce(nullif("p_g_desc", ''), "old_g_desc"),
      "updated_at"  = current_timestamp
  WHERE "groups"."group"."group_uuid" = "p_group_uuid"
    AND "groups"."group"."owner_uuid" = "p_owner_id";
  GET DIAGNOSTICS "n_affected_rows" = ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
