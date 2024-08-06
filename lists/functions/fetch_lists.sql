CREATE OR REPLACE FUNCTION "lists"."fetch"
(
  IN p_owner_uuid "lists"."list"."owner_uuid"%TYPE,
  IN p_group_uuid "groups"."group"."group_uuid"%TYPE,
  IN p_list_uuid  "lists"."list"."list_uuid"%TYPE,
  IN p_needle     TEXT,
  IN p_page       BIGINT,
  IN p_rpp        BIGINT
)
  RETURNS SETOF "lists"."list"
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  today_list_uuid    "lists"."list"."list_uuid"%TYPE;
  tomorrow_list_uuid "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "common"."validate_rpp_and_page"(p_rpp, p_page);
  CALL "common"."gen_search_pattern"(p_needle);
  today_list_uuid := "lists"."get_today_list_uuid"(p_owner_uuid);
  tomorrow_list_uuid := "lists"."get_tomorrow_list_uuid"(p_owner_uuid);
  RETURN QUERY
    SELECT l.*
      FROM "lists"."list" l
      LEFT JOIN "groups"."group" g ON g."group_uuid" = l."group_uuid"
     WHERE l."owner_uuid" = p_owner_uuid
       AND CASE WHEN p_group_uuid <> "addons"."uuid_nil"() AND p_group_uuid IS NOT NULL THEN g."group_uuid" = p_group_uuid ELSE TRUE END
       AND CASE WHEN p_list_uuid IS NOT NULL AND p_list_uuid <> "addons"."uuid_nil"()
                  THEN l."list_uuid" = p_list_uuid
                  ELSE CASE WHEN today_list_uuid IS NOT NULL    THEN l."list_uuid" <> today_list_uuid
                            WHEN tomorrow_list_uuid IS NOT NULL THEN l."list_uuid" <> tomorrow_list_uuid
                                                                ELSE TRUE
                       END
           END
       AND lower(concat(l."name", ' ', l."description")) ~ p_needle
     LIMIT p_rpp OFFSET (p_rpp * (p_page - 1));
END;
$$;
