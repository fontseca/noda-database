CREATE OR REPLACE FUNCTION "users"."fetch_one_user_setting"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE,
  IN "p_setting_key" "users"."setting"."key"%TYPE
)
  RETURNS SETOF "users"."setting"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  CALL "users"."assert_predefined_setting_exists"("p_setting_key");
  RETURN QUERY
    SELECT "us".*
    FROM "users"."setting" "us"
    WHERE "us"."user_uuid" = "p_user_uuid"
      AND "us"."key" = lower("p_setting_key");
END;
$$;
