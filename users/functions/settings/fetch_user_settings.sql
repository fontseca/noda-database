CREATE OR REPLACE FUNCTION "users"."fetch_settings_of"
(
  IN p_user_uuid "users"."user"."user_uuid"%TYPE,
  IN p_needle    TEXT,
  IN p_page      BIGINT,
  IN p_rpp       BIGINT
)
  RETURNS SETOF "users"."setting"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"(p_user_uuid);
  CALL "common"."validate_rpp_and_page"(p_rpp, p_page);
  CALL "common"."gen_search_pattern"(p_needle);
  RETURN QUERY
    SELECT us.*
      FROM "users"."setting" us
      INNER JOIN "users"."predefined_setting" df
                 ON us."key" = df."key"
     WHERE us."user_uuid" = p_user_uuid
       AND lower(concat(us."value", ' ', df."description")) ~ p_needle
     LIMIT p_rpp OFFSET (p_rpp * (p_page - 1));
END;
$$;
