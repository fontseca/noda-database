CREATE OR REPLACE FUNCTION "tasks"."move_one_to_today_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid"   "tasks"."task"."list_uuid"%TYPE;
  "n_affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "tasks"."assert_exists_somewhere"("p_owner_id", "p_task_uuid");
  "today_list_uuid" := "lists"."get_today_list_uuid"("p_owner_id");
  IF "today_list_uuid" IS NULL THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "list_uuid" = "today_list_uuid"
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."task_uuid" = "p_task_uuid";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
