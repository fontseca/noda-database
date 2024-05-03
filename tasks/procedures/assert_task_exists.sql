CREATE OR REPLACE PROCEDURE assert_task_exists
(
  IN p_owner_id "task"."owner_uuid"%TYPE,
  IN p_list_id  "task"."list_uuid"%TYPE,
  IN p_task_id  "task"."task_id"%TYPE
)
LANGUAGE 'plpgsql'
AS $$
DECLARE
  n_records INT;
  task_id_txt TEXT := p_task_id::TEXT;
BEGIN
  IF p_task_id IS NOT NULL THEN
    SELECT count (*)
      INTO n_records
      FROM "task" t
     WHERE t."owner_uuid" = p_owner_id AND
           t."task_id" = p_task_id AND
           t."list_uuid" = p_list_id;
    IF n_records = 1 THEN
      RETURN;
    END IF;
  ELSE
    task_id_txt := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent task with ID "%"', task_id_txt
       USING HINT = 'Please check the given task ID.';
END;
$$;

ALTER PROCEDURE assert_task_exists ("task"."owner_uuid"%TYPE,
                                    "task"."list_uuid"%TYPE,
                                    "task"."task_id"%TYPE)
       OWNER TO "noda";
