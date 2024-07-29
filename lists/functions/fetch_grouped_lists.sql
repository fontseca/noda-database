CREATE OR REPLACE FUNCTION "lists"."fetch_grouped"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_id" "lists"."list"."group_uuid"%TYPE,
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "lists"."list"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "groups"."assert_exists"("p_owner_id", "p_group_id");
  CALL "common"."validate_rpp_and_page"("p_rpp", "p_page");
  CALL "common"."gen_search_pattern"("p_needle");
  CALL "common"."validate_sort_expr"("p_sort_expr");
  RETURN QUERY
    SELECT *
    FROM "lists"."list" "l"
    WHERE "l"."group_uuid" = "p_group_id"
      AND "l"."owner_uuid" = "p_owner_id"
      AND lower(concat("l"."name", ' ', "l"."description")) ~ "p_needle"
      ORDER BY (CASE WHEN "p_sort_expr" = '' THEN "l"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+name' THEN "l"."name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-name' THEN "l"."name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+description' THEN "l"."description" END) ASC,
               (CASE WHEN "p_sort_expr" = '-description' THEN "l"."description" END) DESC
         LIMIT "p_rpp"
        OFFSET ("p_rpp" * ("p_page" - 1));
END;
$$;
