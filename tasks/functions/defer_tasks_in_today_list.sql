CREATE OR REPLACE FUNCTION "tasks"."defer_tasks_in_today_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE
)
  RETURNS INTEGER
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid"    "tasks"."task"."list_uuid"%TYPE;
  "deferred_list_uuid" "tasks"."task"."list_uuid"%TYPE;
  "updated_tasks"    INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  "today_list_uuid" := "lists"."get_today_list_uuid"("p_owner_id");
  "deferred_list_uuid" := "tasks"."get_deferred_list_uuid"("p_owner_id");
  IF "today_list_uuid" IS NULL THEN
    RETURN 0;
  END IF;
  IF "deferred_list_uuid" IS NULL THEN
    "deferred_list_uuid" := "tasks"."make_deferred_list"("p_owner_id");
  END IF;
  WITH "moved_tasks" AS
         (
           UPDATE "tasks"."task"
             SET "list_uuid" = "deferred_list_uuid"
             WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
               AND "tasks"."task"."list_uuid" = "today_list_uuid"
             RETURNING "tasks"."task"."task_uuid")
  SELECT count(*)
  INTO "updated_tasks"
  FROM "moved_tasks";
  RETURN "updated_tasks";
END;
$$;
