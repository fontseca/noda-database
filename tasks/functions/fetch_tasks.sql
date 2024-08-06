CREATE OR REPLACE FUNCTION "tasks"."fetch"
(
  p_owner_uuid "users"."user"."user_uuid"%TYPE,
  p_group_uuid "groups"."group"."group_uuid"%TYPE,
  p_list_uuid  "lists"."list"."list_uuid"%TYPE,
  p_task_uuid  "tasks"."task"."task_uuid"%TYPE,
  p_needle     TEXT,
  p_page       BIGINT,
  p_rpp        BIGINT
)
  RETURNS SETOF "tasks"."task"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "common"."validate_rpp_and_page"(p_rpp, p_page);
  CALL "common"."gen_search_pattern"(p_needle);
  RETURN QUERY
    SELECT t.*
      FROM "tasks"."task" t
      LEFT JOIN "lists"."list" l ON l."list_uuid" = t."list_uuid"
      LEFT JOIN "groups"."group" g ON g."group_uuid" = l."group_uuid"
     WHERE t."owner_uuid" = p_owner_uuid
       AND lower(concat(t."title", '', t."headline", '', t."description")) ~ p_needle
       AND CASE WHEN p_group_uuid <> "addons"."uuid_nil"() AND p_group_uuid IS NOT NULL THEN g."group_uuid" = p_group_uuid ELSE TRUE END
       AND CASE WHEN p_list_uuid <> "addons"."uuid_nil"() AND p_list_uuid IS NOT NULL THEN t."list_uuid" = p_list_uuid ELSE TRUE END
       AND CASE WHEN p_task_uuid <> "addons"."uuid_nil"() AND p_task_uuid IS NOT NULL THEN t."task_uuid" = p_task_uuid ELSE TRUE END
     LIMIT p_rpp OFFSET (p_rpp * (p_page - 1));
END ;
$$;
