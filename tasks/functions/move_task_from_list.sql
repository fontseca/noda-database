CREATE OR REPLACE FUNCTION "tasks"."move_task_from_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE,
  IN "p_dst_list_id" "tasks"."task"."list_uuid"%TYPE
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "tasks"."assert_task_exists_somewhere"("p_owner_id", "p_task_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_dst_list_id");
  UPDATE "tasks"."task"
  SET "list_uuid" = "p_dst_list_id"
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
