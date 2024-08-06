CREATE OR REPLACE FUNCTION "users"."fetch"
(
  IN p_needle TEXT,
  IN p_page   BIGINT,
  IN p_rpp    BIGINT
)
  RETURNS SETOF "users"."user"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "common"."validate_rpp_and_page"(p_rpp, p_page);
  CALL "common"."gen_search_pattern"(p_needle);
  RETURN QUERY
    SELECT *
      FROM "users"."user" special_characters
     WHERE lower(concat(
         special_characters."first_name", ' ',
         special_characters."middle_name", ' ',
         special_characters."last_name", ' ',
         special_characters."surname")) ~ p_needle
     LIMIT p_rpp OFFSET (p_rpp * (p_page - 1));
END;
$$;
