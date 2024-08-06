CREATE OR REPLACE PROCEDURE "tasks"."assert_exists"
(
  IN p_owner_uuid "tasks"."task"."owner_uuid"%TYPE,
  IN p_list_uuid  "tasks"."task"."list_uuid"%TYPE,
  IN p_task_uuid  "tasks"."task"."task_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  n_records     INT;
  task_uuid_txt TEXT := p_task_uuid::TEXT;
BEGIN
  IF p_task_uuid IS NOT NULL
  THEN
    SELECT count(*)
      INTO n_records
      FROM "tasks"."task" t
     WHERE t."owner_uuid" = p_owner_uuid
       AND t."task_uuid" = p_task_uuid
       AND t."list_uuid" = p_list_uuid;
    IF n_records = 1
    THEN
      RETURN;
    END IF;
  ELSE
    task_uuid_txt := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent task with UUID "%"', task_uuid_txt
    USING HINT = 'Please check the given task UUID.';
END;
$$;
