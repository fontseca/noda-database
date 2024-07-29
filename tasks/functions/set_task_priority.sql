CREATE OR REPLACE FUNCTION "tasks"."set_task_priority"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."task_id"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE,
  IN "p_priority" "tasks"."task_priority_t"
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  IF "p_priority" =
     (SELECT "t"."priority"
      FROM "tasks"."task" "t"
      WHERE "t"."owner_uuid" = "p_owner_id"
        AND "t"."list_uuid" = "p_list_id"
        AND "t"."task_id" = "p_task_id")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "priority"   = "p_priority",
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
