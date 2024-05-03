CREATE OR REPLACE FUNCTION fetch_task_by_id
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_list_id  "task"."list_uuid"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE
)
RETURNS SETOF "task"
LANGUAGE 'plpgsql'
AS $$
BEGIN
  CALL users.assert_exists (p_owner_id);
  CALL "lists"."assert_list_exists_somewhere" (p_owner_id, p_list_id);
  CALL assert_task_exists (p_owner_id, p_list_id, p_task_id);
  RETURN QUERY
        SELECT *
          FROM "task" t
         WHERE t."owner_uuid" = p_owner_id AND
               t."list_uuid" = p_list_id AND
               t."task_id" = p_task_id;
END;
$$;

ALTER FUNCTION fetch_task_by_id ("task"."owner_uuid"%TYPE,
                                 "task"."list_uuid"%TYPE,
                                 "task"."task_id"%TYPE)
      OWNER TO "noda";
