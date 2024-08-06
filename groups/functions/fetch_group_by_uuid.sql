CREATE OR REPLACE FUNCTION "groups"."fetch_by_uuid"
(
  IN p_owner_uuid "groups"."group"."owner_uuid"%TYPE,
  IN p_group_uuid "groups"."group"."group_uuid"%TYPE
)
  RETURNS SETOF "groups"."group"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "groups"."assert_exists"("p_owner_uuid", p_group_uuid);
  RETURN QUERY
    SELECT *
      FROM "groups"."group"
     WHERE "group_uuid" = p_group_uuid
       AND "owner_uuid" = p_owner_uuid;
END;
$$;
