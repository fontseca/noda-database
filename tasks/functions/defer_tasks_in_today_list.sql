CREATE OR REPLACE FUNCTION defer_tasks_in_today_list
(
  IN p_owner_id "task"."owner_uuid"%TYPE
)
RETURNS INTEGER
RETURNS NULL ON NULL INPUT
LANGUAGE 'plpgsql'
AS $$
DECLARE
  today_list_id "task"."list_uuid"%TYPE;
  deferred_list_id "task"."list_uuid"%TYPE;
  updated_tasks INTEGER;
BEGIN
  CALL users.assert_exists (p_owner_id);
  today_list_id := "lists"." get_today_list_id"(p_owner_id);
  deferred_list_id := get_deferred_list_id (p_owner_id);
  IF today_list_id IS NULL THEN
    RETURN 0;
  END IF;
  IF deferred_list_id IS NULL THEN
    deferred_list_id := make_deferred_list (p_owner_id);
  END IF;
  WITH "moved_tasks" AS
  (
       UPDATE "task"
          SET "list_uuid" = deferred_list_id
        WHERE "task"."owner_uuid" = p_owner_id
          AND "task"."list_uuid" = today_list_id
    RETURNING "task"."task_id"
  )
  SELECT count (*)
    INTO updated_tasks
    FROM "moved_tasks";
  RETURN updated_tasks;
END;
$$;

ALTER FUNCTION defer_tasks_in_today_list ("task"."owner_uuid"%TYPE)
      OWNER TO "noda";
