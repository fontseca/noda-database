CREATE OR REPLACE FUNCTION "lists"."get_today_list_id"(
  IN "p_user_id" "lists"."list"."owner_uuid"%TYPE
)
  RETURNS uuid
  LANGUAGE 'sql'
AS
$$
  /* TODO: Convert to PL/pgSQL function to assert user existence. */
SELECT "list_uuid"
FROM "lists"."user_special_list"
WHERE "user_uuid" = "p_user_id"
  AND "list_type" = 'today';
$$;
