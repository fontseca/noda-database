CREATE OR REPLACE FUNCTION "groups"."delete"
(
  IN p_owner_uuid "groups"."group"."owner_uuid"%TYPE,
  IN p_group_uuid "groups"."group"."group_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  n_affected_rows INT;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "groups"."assert_exists"(p_owner_uuid, p_group_uuid);
  DELETE
    FROM "groups"."group"
   WHERE "group_uuid" = p_group_uuid
     AND "owner_uuid" = p_owner_uuid;
  GET DIAGNOSTICS n_affected_rows := ROW_COUNT;
  RETURN n_affected_rows;
END;
$$;
