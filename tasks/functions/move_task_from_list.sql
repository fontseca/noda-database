CREATE OR REPLACE FUNCTION move_task_from_list
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE,
  IN p_dst_list_id "task"."list_uuid"%TYPE
)
RETURNS BOOLEAN
RETURNS NULL ON NULL INPUT
LANGUAGE 'plpgsql'
AS $$
DECLARE
  n_affected_rows INTEGER;
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL assert_task_exists_somewhere (p_owner_id, p_task_id);
  CALL "lists"."assert_list_exists_somewhere" (p_owner_id, p_dst_list_id);
  UPDATE "task"
     SET "list_uuid" = p_dst_list_id
   WHERE "task"."owner_uuid" = p_owner_id
     AND "task"."task_id" = p_task_id;
  GET DIAGNOSTICS n_affected_rows := ROW_COUNT;
  RETURN n_affected_rows;
END;
$$;

ALTER FUNCTION move_task_from_list ("task"."owner_uuid"%TYPE,
                                    "task"."task_id"%TYPE,
                                    "task"."list_uuid"%TYPE)
      OWNER TO "noda";
