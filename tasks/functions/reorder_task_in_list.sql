CREATE OR REPLACE FUNCTION "tasks"."reorder_task_in_list"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."list_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE,
  IN "target_position" "common"."pos_t"
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_task_id"       "tasks"."task"."task_id"%TYPE;
  "obsolete_task_position" "common"."pos_t" := 1;
  "affected_rows"          INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  IF "tasks"."compute_next_task_pos"("p_list_id") <= "target_position" THEN
    RETURN FALSE;
  END IF;
  SELECT "t"."task_id",
         "t"."position_in_list"
  INTO "affected_task_id"
  FROM "tasks"."task" "t"
  WHERE "t"."owner_uuid" = "p_owner_id"
    AND "t"."list_uuid" = "p_list_id"
    AND "t"."position_in_list" = "target_position";
  SELECT "t"."position_in_list"
  INTO "obsolete_task_position"
  FROM "tasks"."task" "t"
  WHERE "t"."owner_uuid" = "p_owner_id"
    AND "t"."list_uuid" = "p_list_id"
    AND "t"."task_id" = "p_task_id";
  IF "target_position" = "obsolete_task_position" THEN
    RETURN FALSE;
  END IF;
  /* Current task.  */
  UPDATE "tasks"."task"
  SET "position_in_list" = "target_position",
      "updated_at"       = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  /* Affected task.  */
  UPDATE "tasks"."task"
  SET "position_in_list" = "obsolete_task_position",
      "updated_at"       = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_id"
    AND "tasks"."task"."task_id" = "affected_task_id";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
