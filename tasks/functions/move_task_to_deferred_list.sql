CREATE OR REPLACE FUNCTION move_task_to_deferred_list
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE
)
RETURNS BOOLEAN
RETURNS NULL ON NULL INPUT
LANGUAGE 'plpgsql'
AS $$
DECLARE
  deferred_list_id "task"."list_uuid"%TYPE;
  n_affected_rows INTEGER;
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL assert_task_exists_somewhere (p_owner_id, p_task_id);
  deferred_list_id := get_deferred_list_id (p_owner_id);
  IF deferred_list_id IS NULL THEN
    RETURN FALSE;
  END IF;
  UPDATE "task"
     SET "list_uuid" = deferred_list_id
   WHERE "task"."owner_uuid" = p_owner_id
     AND "task"."task_id" = p_task_id;
  GET DIAGNOSTICS n_affected_rows := ROW_COUNT;
  RETURN n_affected_rows;
END;
$$;

ALTER FUNCTION move_task_to_deferred_list ("task"."owner_uuid"%TYPE,
                                           "task"."task_id"%TYPE)
      OWNER TO "noda";
