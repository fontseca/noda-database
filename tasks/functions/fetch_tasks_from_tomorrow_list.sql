CREATE OR REPLACE FUNCTION "tasks"."fetch_tasks_from_tomorrow_list"(
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
  "tomorrow_list_uuid" "lists"."list"."list_uuid"%TYPE;
BEGIN
  SELECT "lists"."get_tomorrow_list_uuid"("p_owner_id")
  INTO "tomorrow_list_uuid";
  IF "tomorrow_list_uuid" IS NULL THEN
    RETURN;
  END IF;
  RETURN QUERY
    SELECT *
    FROM "tasks"."fetch_tasks"("p_owner_id",
                               "tomorrow_list_uuid",
                               "p_page",
                               "p_rpp",
                               "p_needle",
                               "p_sort_expr");
END ;
$$;
