CREATE OR REPLACE FUNCTION "tasks"."duplicate"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "current_task"  "tasks"."task"%ROWTYPE;
  "new_task_uuid" "tasks"."task"."task_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "tasks"."assert_exists_somewhere"("p_owner_id", "p_task_uuid");
  SELECT *
  INTO "current_task"
  FROM "tasks"."task"
  WHERE "owner_uuid" = "p_owner_id"
    AND "task_uuid" = "p_task_uuid";
  "new_task_uuid" := "tasks"."make"("p_owner_id",
                                    "current_task"."list_uuid",
                                    ROW ("current_task"."title",
                                      "current_task"."headline",
                                      "current_task"."description",
                                      "current_task"."priority",
                                      "current_task"."status",
                                      "current_task"."due_date",
                                      "current_task"."remind_at"));
  /* TODO: Duplicate all steps and attachments.  */
  RETURN "new_task_uuid";
END;
$$;
