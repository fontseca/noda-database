CREATE OR REPLACE FUNCTION "lists"."fetch_scattered"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "lists"."list"
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_id"    uuid;
  "tomorrow_list_id" uuid;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "common"."validate_rpp_and_page"("p_rpp", "p_page");
  CALL "common"."gen_search_pattern"("p_needle");
  CALL "common"."validate_sort_expr"("p_sort_expr");
  "today_list_id" := "lists"."get_today_list_id"("p_owner_id");
  "tomorrow_list_id" := "lists"."get_tomorrow_list_id"("p_owner_id");
  RETURN QUERY
    SELECT *
    FROM "lists"."list" "l"
    WHERE "l"."owner_uuid" = "p_owner_id"
      AND "l"."group_uuid" IS NULL
      AND CASE
            WHEN "today_list_id" IS NULL
              THEN TRUE
            ELSE "l"."list_uuid" <> "today_list_id"
      END
      AND CASE
            WHEN "tomorrow_list_id" IS NULL
              THEN TRUE
            ELSE "l"."list_uuid" <> "tomorrow_list_id"
      END
      AND lower(concat("l"."name", ' ', "l"."description")) ~ "p_needle"
      ORDER BY (CASE WHEN "p_sort_expr" = '' THEN "l"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+name' THEN "l"."name" END) ASC,
               (CASE WHEN "p_sort_expr" = '-name' THEN "l"."name" END) DESC,
               (CASE WHEN "p_sort_expr" = '+description' THEN "l"."description" END) ASC,
               (CASE WHEN "p_sort_expr" = '-description' THEN "l"."description" END) DESC,
               (CASE WHEN "p_sort_expr" = '+created_at' THEN "l"."created_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-created_at' THEN "l"."created_at" END) DESC,
               (CASE WHEN "p_sort_expr" = '+updated_at' THEN "l"."updated_at" END) ASC,
               (CASE WHEN "p_sort_expr" = '-updated_at' THEN "l"."updated_at" END) DESC
         LIMIT "p_rpp"
        OFFSET ("p_rpp" * ("p_page" - 1));
END;
$$;
