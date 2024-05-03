CREATE OR REPLACE FUNCTION "users"."fetch_one_user_setting"(
  IN "p_user_id" "users"."user"."user_uuid"%TYPE,
  IN "p_setting_key" "users"."setting"."key"%TYPE
)
  RETURNS TABLE
          (
            "key"         "users"."predefined_setting"."key"%TYPE,
            "description" "users"."predefined_setting"."description"%TYPE,
            "value"       "users"."predefined_setting"."default_value"%TYPE,
            "created_at"  "users"."setting"."created_at"%TYPE,
            "updated_at"  "users"."setting"."updated_at"%TYPE
          )
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_user_id");
  CALL "users"."assert_predefined_setting_exists"("p_setting_key");
  RETURN QUERY
    SELECT "us"."key",
           "df"."description",
           "us"."value",
           "us"."created_at",
           "us"."updated_at"
    FROM "users"."setting" "us"
           INNER JOIN "users"."predefined_setting" "df"
                      ON "us"."key" = "df"."key"
    WHERE "us"."user_uuid" = "p_user_id"
      AND "us"."key" = lower("p_setting_key");
END;
$$;
