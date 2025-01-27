CREATE OR REPLACE FUNCTION "tasks"."delete"
(
  IN p_owner_uuid  "tasks"."task"."owner_uuid"%TYPE,
  IN p_list_uuid   "tasks"."task"."list_uuid"%TYPE,
  IN p_task_uuid "tasks"."task"."task_uuid"%TYPE
)
  RETURNS VOID
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "lists"."assert_exists_somewhere"(p_list_uuid, p_owner_uuid);
  CALL "tasks"."assert_exists"(p_owner_uuid, p_list_uuid, p_task_uuid);
  DELETE
    FROM "tasks"."task"
   WHERE "tasks"."task"."owner_uuid" = p_owner_uuid
     AND "tasks"."task"."list_uuid" = p_list_uuid
     AND "tasks"."task"."task_uuid" = p_task_uuid;
END;
$$;
