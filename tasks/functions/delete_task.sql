CREATE OR REPLACE FUNCTION "tasks"."delete_task"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."list_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE
)
  RETURNS VOID
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_list_id", "p_owner_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  DELETE
  FROM "tasks"."task"
  WHERE"tasks"."task"."owner_uuid" = "p_owner_id"
    AND"tasks"."task"."list_uuid" = "p_list_id"
    AND"tasks"."task"."task_id" = "p_task_id";
END;
$$;
