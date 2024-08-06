CREATE OR REPLACE FUNCTION "tasks"."defer_all_in_today_list"
(
  IN p_owner_uuid "tasks"."task"."owner_uuid"%TYPE
)
  RETURNS INTEGER
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  today_list_uuid    "tasks"."task"."list_uuid"%TYPE;
  deferred_list_uuid "tasks"."task"."list_uuid"%TYPE;
  updated_tasks      INTEGER;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  today_list_uuid := "lists"."get_today_list_uuid"(p_owner_uuid);
  deferred_list_uuid := "tasks"."get_deferred_list_uuid"(p_owner_uuid);
  IF today_list_uuid IS NULL
  THEN
    RETURN 0;
  END IF;
  IF deferred_list_uuid IS NULL
  THEN
    deferred_list_uuid := "tasks"."make_deferred_list"(p_owner_uuid);
  END IF;
    WITH "moved_tasks" AS (
      UPDATE "tasks"."task"
        SET "list_uuid" = deferred_list_uuid
        WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
          AND "tasks"."task"."list_uuid" = today_list_uuid
        RETURNING "tasks"."task"."task_uuid")
  SELECT count(*)
    INTO updated_tasks
    FROM "moved_tasks";
  RETURN updated_tasks;
END;
$$;
