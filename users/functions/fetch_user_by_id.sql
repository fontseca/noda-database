CREATE OR REPLACE FUNCTION "users"."fetch_by_id"(
  IN "p_user_id" "users"."user"."user_uuid"%TYPE
)
  RETURNS "users"."user"
  LANGUAGE 'sql'
AS
$$
SELECT *
FROM "users"."fetch_by"('user_id', "p_user_id"::TEXT)
$$;
