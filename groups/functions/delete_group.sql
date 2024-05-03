CREATE OR REPLACE FUNCTION "groups"."delete"(
  IN "p_owner_id" "groups"."group"."owner_uuid"%TYPE,
  IN "p_group_id" "groups"."group"."group_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows" INT;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "groups"."assert_exists"("p_owner_id", "p_group_id");
  DELETE
  FROM "groups"."group"
  WHERE "group_uuid" = "p_group_id"
    AND "owner_uuid" = "p_owner_id";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
