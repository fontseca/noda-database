CREATE OR REPLACE FUNCTION "tasks"."set_task_due_date"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_uuid" "tasks"."task"."task_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE,
  IN "p_due_date" timestamptz
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_uuid");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_uuid", "p_task_uuid");
  IF now() >= "p_due_date" THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "due_date"   = "p_due_date",
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_uuid"
    AND "tasks"."task"."task_uuid" = "p_task_uuid";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
