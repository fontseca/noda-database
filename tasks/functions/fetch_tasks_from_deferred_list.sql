CREATE OR REPLACE FUNCTION "tasks"."fetch_tasks_from_deferred_list"(
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
  "deferred_list_id" "lists"."list"."list_uuid"%TYPE;
BEGIN
  SELECT "list_uuid"
  INTO "deferred_list_id"
  FROM "lists"."user_special_list" "s"
  WHERE "s"."user_uuid" = "p_owner_id"
    AND "s"."list_type" = 'deferred'::special_list_type_t;
  IF "deferred_list_id" IS NULL THEN
    RETURN;
  END IF;
  RETURN QUERY
    SELECT *
    FROM "tasks"."fetch_tasks"("p_owner_id",
                               "deferred_list_id",
                               "p_page",
                               "p_rpp",
                               "p_needle",
                               "p_sort_expr");
END;
$$;
