CREATE OR REPLACE FUNCTION "tasks"."move_one_to_deferred_list"
(
  IN p_owner_uuid "tasks"."task"."owner_uuid"%TYPE,
  IN p_task_uuid  "tasks"."task"."task_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  deferred_list_uuid "tasks"."task"."list_uuid"%TYPE;
  n_affected_rows    INTEGER;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "tasks"."assert_exists_somewhere"(p_owner_uuid, p_task_uuid);
  deferred_list_uuid := "lists"."get_deferred_list_uuid"(p_owner_uuid);
  IF deferred_list_uuid IS NULL
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
     SET "list_uuid" = deferred_list_uuid
   WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
     AND "tasks"."task"."task_uuid" = p_task_uuid;
  GET DIAGNOSTICS n_affected_rows := ROW_COUNT;
  RETURN n_affected_rows;
END;
$$;
