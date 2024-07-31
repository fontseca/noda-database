CREATE OR REPLACE FUNCTION "tasks"."set_priority"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_uuid" "tasks"."task"."task_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE,
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
  CALL "lists"."assert_exists_somewhere"("p_owner_id", "p_list_uuid");
  CALL "tasks"."assert_exists"("p_owner_id", "p_list_uuid", "p_task_uuid");
  IF "p_priority" =
     (SELECT "t"."priority"
      FROM "tasks"."task" "t"
      WHERE "t"."owner_uuid" = "p_owner_id"
        AND "t"."list_uuid" = "p_list_uuid"
        AND "t"."task_uuid" = "p_task_uuid")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "priority"   = "p_priority",
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_uuid"
    AND "tasks"."task"."task_uuid" = "p_task_uuid";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
