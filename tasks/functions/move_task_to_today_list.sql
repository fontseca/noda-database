CREATE OR REPLACE FUNCTION "tasks"."move_task_to_today_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_id"   "tasks"."task"."list_uuid"%TYPE;
  "n_affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "tasks"."assert_task_exists_somewhere"("p_owner_id", "p_task_id");
  "today_list_id" := "lists"."get_today_list_id"("p_owner_id");
  IF "today_list_id" IS NULL THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "list_uuid" = "today_list_id"
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
