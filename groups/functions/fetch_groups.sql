CREATE OR REPLACE FUNCTION "groups"."fetch"(
  IN "p_owner_id" "groups"."group"."owner_uuid"%TYPE,
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "groups"."group"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "common"."validate_rpp_and_page"("p_rpp", "p_page");
  CALL "common"."gen_search_pattern"("p_needle");
  CALL "common"."validate_sort_expr"("p_sort_expr");
  RETURN QUERY
    SELECT *
    FROM "groups"."group" "g"
    WHERE lower(concat("g"."name", ' ', "g"."description")) ~ "p_needle"
      ORDER BY (CASE WHEN "p_sort_expr" = '' THEN "g"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+name' THEN "g"."name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-name' THEN "g"."name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+description' THEN "g"."description" END) ASC,
               (CASE WHEN "p_sort_expr" = '-description' THEN "g"."description" END) DESC,
               (CASE WHEN "p_sort_expr" = '+created_at' THEN "g"."created_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-created_at' THEN "g"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+updated_at' THEN "g"."updated_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-updated_at' THEN "g"."updated_at" END) DESC
         LIMIT "p_rpp"
        OFFSET ("p_rpp" * ("p_page" - 1));
END;
$$;
