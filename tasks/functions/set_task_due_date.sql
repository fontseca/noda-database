CREATE OR REPLACE FUNCTION "tasks"."set_due_date"
(
  IN p_owner_uuid "tasks"."task"."owner_uuid"%TYPE,
  IN p_list_uuid  "tasks"."task"."task_uuid"%TYPE,
  IN p_task_uuid  "tasks"."task"."task_uuid"%TYPE,
  IN p_due_date   timestamptz
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  affected_rows INTEGER;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "lists"."assert_exists_somewhere"(p_owner_uuid, p_list_uuid);
  CALL "tasks"."assert_exists"(p_owner_uuid, p_list_uuid, p_task_uuid);
  IF current_timestamp >= p_due_date
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
     SET "due_date"   = p_due_date,
         "updated_at" = current_timestamp
   WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
     AND "tasks"."task"."list_uuid" = p_list_uuid
     AND "tasks"."task"."task_uuid" = p_task_uuid;
  GET DIAGNOSTICS affected_rows := ROW_COUNT;
  RETURN affected_rows;
END;
$$;
