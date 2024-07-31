CREATE OR REPLACE FUNCTION "tasks"."fetch_from_today_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_page" BIGINT,
  IN "p_rpp" BIGINT,
  IN "p_needle" TEXT,
  IN "p_sort_expr" TEXT
)
  RETURNS SETOF "tasks"."task"
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid" "lists"."list"."list_uuid"%TYPE;
BEGIN
  SELECT "lists"."get_today_list_uuid"("p_owner_id")
  INTO "today_list_uuid";
  IF "today_list_uuid" IS NULL THEN
    RETURN;
  END IF;
  RETURN QUERY
    SELECT *
    FROM "tasks"."fetch"("p_owner_id",
                         "today_list_uuid",
                         "p_page",
                         "p_rpp",
                         "p_needle",
                         "p_sort_expr");
END;
$$;
