CREATE OR REPLACE FUNCTION "users"."fetch_by_uuid"
(
  IN p_user_uuid "users"."user"."user_uuid"%TYPE
)
  RETURNS "users"."user"
  LANGUAGE 'sql'
AS
$$
SELECT *
  FROM "users"."fetch_by"('user_uuid', p_user_uuid::TEXT)
$$;
