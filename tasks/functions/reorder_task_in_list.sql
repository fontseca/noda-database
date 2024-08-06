CREATE OR REPLACE FUNCTION "tasks"."reorder_task_in_list"
(
  IN p_owner_uuid    "tasks"."task"."owner_uuid"%TYPE,
  IN p_list_uuid     "tasks"."task"."list_uuid"%TYPE,
  IN p_task_uuid     "tasks"."task"."task_uuid"%TYPE,
  IN target_position "common"."pos_t"
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  affected_task_uuid     "tasks"."task"."task_uuid"%TYPE;
  obsolete_task_position "common"."pos_t" := 1;
  affected_rows          INTEGER;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "lists"."assert_exists_somewhere"(p_owner_uuid, p_list_uuid);
  CALL "tasks"."assert_exists"(p_owner_uuid, p_list_uuid, p_task_uuid);
  IF "tasks"."compute_next_position"(p_list_uuid) <= target_position
  THEN
    RETURN FALSE;
  END IF;
  SELECT t."task_uuid",
         t."position_in_list"
    INTO affected_task_uuid
    FROM "tasks"."task" t
   WHERE t."owner_uuid" = p_owner_uuid
     AND t."list_uuid" = p_list_uuid
     AND t."position_in_list" = target_position;
  SELECT t."position_in_list"
    INTO obsolete_task_position
    FROM "tasks"."task" t
   WHERE t."owner_uuid" = p_owner_uuid
     AND t."list_uuid" = p_list_uuid
     AND t."task_uuid" = p_task_uuid;
  IF target_position = obsolete_task_position
  THEN
    RETURN FALSE;
  END IF;
  /* Current task.  */
  UPDATE "tasks"."task"
     SET "position_in_list" = target_position,
         "updated_at"       = current_timestamp
   WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
     AND "tasks"."task"."list_uuid" = p_list_uuid
     AND "tasks"."task"."task_uuid" = p_task_uuid;
  /* Affected task.  */
  UPDATE "tasks"."task"
     SET "position_in_list" = obsolete_task_position,
         "updated_at"       = current_timestamp
   WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
     AND "tasks"."task"."list_uuid" = p_list_uuid
     AND "tasks"."task"."task_uuid" = affected_task_uuid;
  GET DIAGNOSTICS affected_rows := ROW_COUNT;
  RETURN affected_rows;
END;
$$;
