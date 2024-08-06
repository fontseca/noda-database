CREATE OR REPLACE FUNCTION "users"."fetch_by_email"
(
  IN p_user_email TEXT
)
  RETURNS "users"."user"
  LANGUAGE 'sql'
AS
$$
SELECT *
  FROM "users"."fetch_by"('email', p_user_email)
$$;
