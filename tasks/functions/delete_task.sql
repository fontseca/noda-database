CREATE OR REPLACE FUNCTION delete_task
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_list_id  "task"."list_uuid"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE
)
RETURNS VOID
RETURNS NULL ON NULL INPUT
LANGUAGE 'plpgsql'
AS $$
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL "lists"."assert_list_exists_somewhere" (p_list_id, p_owner_id);
  CALL assert_task_exists (p_owner_id, p_list_id, p_task_id);
  DELETE FROM "task"
        WHERE "task"."owner_uuid" = p_owner_id
          AND "task"."list_uuid" = p_list_id
          AND "task".task_id = p_task_id;
END;
$$;

ALTER FUNCTION delete_task ()
      OWNER TO "noda";
