CREATE OR REPLACE FUNCTION "tasks"."update"
(
  IN p_owner_uuid "tasks"."task"."owner_uuid"%TYPE,
  IN p_list_uuid  "tasks"."task"."list_uuid"%TYPE,
  IN p_task_uuid  "tasks"."task"."task_uuid"%TYPE,
  IN p_update     "tasks"."task_update_t"
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  last_update   "tasks"."task_update_t";
  affected_rows INTEGER := 0;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "tasks"."assert_exists"(p_owner_uuid, p_list_uuid, p_task_uuid);
  SELECT "title",
         "headline",
         "description"
    INTO last_update."title",
      last_update."headline",
      last_update."description"
    FROM "tasks"."task" t
   WHERE t."owner_uuid" = p_owner_uuid
     AND t."list_uuid" = p_list_uuid
     AND t."task_uuid" = p_task_uuid;
  p_update."title" := trim(BOTH ' ' FROM p_update."title");
  p_update."headline" := trim(BOTH ' ' FROM p_update."headline");
  p_update."description" := trim(BOTH ' ' FROM p_update."description");
  IF (p_update."title" IS NULL OR p_update."title" = last_update."title") AND
     (p_update."headline" IS NULL OR p_update."headline" = last_update."headline") AND
     (p_update."description" IS NULL OR p_update."description" = last_update."description")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
     SET "title"       = coalesce(p_update."title", last_update."title"),
         "headline"    = coalesce(p_update."headline", last_update."headline"),
         "description" = coalesce(p_update."description", last_update."description"),
         "updated_at"  = current_timestamp
   WHERE "owner_uuid" = p_owner_uuid
     AND "list_uuid" = p_list_uuid
     AND "task_uuid" = p_task_uuid;
  GET DIAGNOSTICS affected_rows := ROW_COUNT;
  RETURN affected_rows;
END;
$$;
