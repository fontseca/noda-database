CREATE OR REPLACE FUNCTION "lists"."get_deferred_list_uuid"
(
  IN p_user_uuid "lists"."list"."owner_uuid"%TYPE
)
  RETURNS uuid
  LANGUAGE 'sql'
AS
$$
SELECT "list_uuid"
  FROM "lists"."user_special_list"
 WHERE "user_uuid" = p_user_uuid
   AND "list_type" = 'deferred';
$$;
