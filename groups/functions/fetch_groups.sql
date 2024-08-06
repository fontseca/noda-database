CREATE OR REPLACE FUNCTION "groups"."fetch"
(
  IN p_owner_uuid "groups"."group"."owner_uuid"%TYPE,
  IN p_group_uuid "groups"."group"."group_uuid"%TYPE,
  IN p_needle     TEXT,
  IN p_page       BIGINT,
  IN p_rpp        BIGINT
)
  RETURNS SETOF "groups"."group"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "common"."validate_rpp_and_page"(p_rpp, p_page);
  CALL "common"."gen_search_pattern"(p_needle);
  RETURN QUERY
    SELECT *
      FROM "groups"."group" g
     WHERE lower(concat(g."name", ' ', g."description")) ~ p_needle
       AND g."owner_uuid" = p_owner_uuid
       AND CASE WHEN p_group_uuid <> "addons"."uuid_nil"() AND p_group_uuid IS NOT NULL THEN g."group_uuid" = p_group_uuid ELSE TRUE END
     LIMIT p_rpp OFFSET (p_rpp * (p_page - 1));
END;
$$;
