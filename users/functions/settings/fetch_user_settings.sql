CREATE OR REPLACE FUNCTION "users"."fetch_settings_of"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE,
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "users"."setting"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  CALL "common"."validate_rpp_and_page"("p_rpp", "p_page");
  CALL "common"."validate_sort_expr"("p_sort_expr");
  CALL "common"."gen_search_pattern"("p_needle");
  RETURN QUERY
    SELECT "us".*
    FROM "users"."setting" "us"
           INNER JOIN "users"."predefined_setting" "df"
                      ON "us"."key" = "df"."key"
    WHERE "us"."user_uuid" = "p_user_uuid"
      AND lower(concat("us"."value", ' ', "df"."description")) ~ "p_needle"
      ORDER BY (CASE WHEN "p_sort_expr" = '' THEN "us"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+key' THEN "us"."key" END) ASC,
               (CASE WHEN "p_sort_expr" = '-key' THEN "us"."key" END) DESC,
               (CASE WHEN "p_sort_expr" = '+description' THEN "df"."description" END) ASC,
               (CASE WHEN "p_sort_expr" = '-description' THEN "df"."description" END) DESC,
               (CASE WHEN "p_sort_expr" = '+created_at' THEN "us"."created_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-created_at' THEN "us"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+updated_at' THEN "us"."updated_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-updated_at' THEN "us"."updated_at" END) DESC
         LIMIT "p_rpp"
        OFFSET ("p_rpp" * ("p_page" - 1));
END;
$$;
