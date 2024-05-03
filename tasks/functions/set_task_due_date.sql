CREATE OR REPLACE FUNCTION set_task_due_date
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_list_id  "task"."task_id"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE,
  IN p_due_date TIMESTAMPTZ
)
RETURNS BOOLEAN
LANGUAGE 'plpgsql'
AS $$
DECLARE
  affected_rows INTEGER;
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL "lists"."assert_list_exists_somewhere" (p_owner_id, p_list_id);
  CALL assert_task_exists (p_owner_id, p_list_id, p_task_id);
  IF now () >= p_due_date THEN
    RETURN FALSE;
  END IF;
  UPDATE "task"
     SET "due_date" = p_due_date,
         "updated_at" = now ()
   WHERE "task"."owner_uuid" = p_owner_id
     AND "task"."list_uuid" = p_list_id
     AND "task"."task_id" = p_task_id;
  GET DIAGNOSTICS affected_rows := ROW_COUNT;
  RETURN affected_rows;
END;
$$;

ALTER FUNCTION set_task_due_date ("task"."owner_uuid"%TYPE,
                                  "task"."task_id"%TYPE,
                                  "task"."task_id"%TYPE,
                                  TIMESTAMPTZ)
      OWNER TO "noda";
