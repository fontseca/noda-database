CREATE OR REPLACE FUNCTION "users"."fetch_blocked"(
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "users"."blocked_user"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "common"."validate_rpp_and_page"("p_rpp", "p_page");
  CALL "common"."gen_search_pattern"("p_needle");
  CALL "common"."validate_sort_expr"("p_sort_expr");
  RETURN QUERY
    SELECT *
    FROM "blocked_user" "u"
    WHERE lower(concat(
        "u"."first_name", ' ',
        "u"."middle_name", ' ',
        "u"."last_name", ' ',
        "u"."surname")) ~ "p_needle"
      ORDER BY (CASE WHEN "p_sort_expr" = '' THEN "u"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+user_uuid' THEN "u"."user_uuid" END) ASC,
               (CASE WHEN "p_sort_expr" = '-user_uuid' THEN "u"."user_uuid" END) DESC,
               (CASE WHEN "p_sort_expr" = '+first_name' THEN "u"."first_name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-first_name' THEN "u"."first_name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+middle_name' THEN "u"."middle_name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-middle_name' THEN "u"."middle_name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+last_name' THEN "u"."last_name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-last_name' THEN "u"."last_name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+surname' THEN "u"."surname" END) ASC,
               (CASE WHEN "p_sort_expr" = '-surname' THEN "u"."surname" END) DESC,
               (CASE WHEN "p_sort_expr" = '+email' THEN "u"."email" END) ASC,
               (CASE WHEN "p_sort_expr" = '-email' THEN "u"."email" END) DESC,
               (CASE WHEN "p_sort_expr" = '+created_at' THEN "u"."created_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-created_at' THEN "u"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+updated_at' THEN "u"."updated_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-updated_at' THEN "u"."updated_at" END) DESC
         LIMIT "p_rpp"
        OFFSET ("p_rpp" * ("p_page" - 1));
END;
$$;
