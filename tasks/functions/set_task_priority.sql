CREATE OR REPLACE FUNCTION set_task_priority
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_list_id  "task"."task_id"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE,
  IN p_priority task_priority_t
)
RETURNS BOOLEAN
RETURNS NULL ON NULL INPUT
LANGUAGE 'plpgsql'
AS $$
DECLARE
  affected_rows INTEGER;
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL "lists"."assert_list_exists_somewhere" (p_owner_id, p_list_id);
  CALL assert_task_exists (p_owner_id, p_list_id, p_task_id);
  IF p_priority =
  (
    SELECT t."priority"
      FROM "task" t
     WHERE t."owner_uuid" = p_owner_id
       AND t."list_uuid" = p_list_id
       AND t."task_id" = p_task_id
  )
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "task"
     SET "priority" = p_priority,
         "updated_at" = now ()
   WHERE "task"."owner_uuid" = p_owner_id
     AND "task"."list_uuid" = p_list_id
     AND "task"."task_id" = p_task_id;
  GET DIAGNOSTICS affected_rows := ROW_COUNT;
  RETURN affected_rows;
END;
$$;

ALTER FUNCTION set_task_priority ("task"."owner_uuid"%TYPE,
                                  "task"."task_id"%TYPE,
                                  "task"."task_id"%TYPE,
                                  task_priority_t)
      OWNER TO "noda";
