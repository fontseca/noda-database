CREATE OR REPLACE FUNCTION "tasks"."move_tasks_from_tomorrow_to_today_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE
)
  RETURNS INTEGER
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid"    "tasks"."task"."list_uuid"%TYPE;
  "tomorrow_list_uuid" "tasks"."task"."list_uuid"%TYPE;
  "n_updated_tasks"  INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  "today_list_uuid" := "lists"."get_today_list_uuid"("p_owner_id");
  "tomorrow_list_uuid" := "lists"."get_tomorrow_list_uuid"("p_owner_id");
  IF "today_list_uuid" IS NULL
    OR "tomorrow_list_uuid" IS NULL
  THEN
    RETURN 0;
  END IF;
  WITH "moved_tasks" AS
         (
           UPDATE "tasks"."task"
             SET "list_uuid" = "today_list_uuid"
             WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
               AND "tasks"."task"."list_uuid" = "tomorrow_list_uuid"
             RETURNING "tasks"."task"."task_uuid")
  SELECT count(*)
  INTO "n_updated_tasks"
  FROM "moved_tasks";
  RETURN "n_updated_tasks";
END;
$$;
