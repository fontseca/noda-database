CREATE OR REPLACE FUNCTION "tasks"."move_one_from_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE,
  IN "p_dst_list_uuid" "tasks"."task"."list_uuid"%TYPE
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
  CALL "tasks"."assert_exists_somewhere"("p_owner_id", "p_task_uuid");
  CALL "lists"."assert_exists_somewhere"("p_owner_id", "p_dst_list_uuid");
  UPDATE "tasks"."task"
  SET "list_uuid" = "p_dst_list_uuid"
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."task_uuid" = "p_task_uuid";
  GET DIAGNOSTICS "n_affected_rows" := ROW_COUNT;
  RETURN "n_affected_rows";
END;
$$;
