CREATE OR REPLACE FUNCTION "tasks"."restore_from_trash"
(
  IN p_owner_uuid "tasks"."task"."task_uuid"%TYPE,
  IN p_list_uuid  "tasks"."task"."list_uuid"%TYPE,
  IN p_task_uuid  "tasks"."task"."task_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  n_inserted_rows INTEGER;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "lists"."assert_exists_somewhere"(p_owner_uuid, p_list_uuid);
  IF 0 = (SELECT count(1)
            FROM "tasks"."trashed_task" t
           WHERE t."owner_uuid" = p_owner_uuid
             AND t."list_uuid" = p_list_uuid
             AND t."task_uuid" = p_task_uuid)
  THEN
    RETURN FALSE;
  END IF;
    WITH "moved_task" AS
           (
             DELETE FROM "tasks"."trashed_task"
               WHERE "owner_uuid" = p_owner_uuid
                 AND "list_uuid" = p_list_uuid
                 AND "task_uuid" = p_task_uuid
               RETURNING *)
  INSERT
    INTO "tasks"."task" ("task_uuid",
                         "owner_uuid",
                         "list_uuid",
                         "position_in_list",
                         "title",
                         "headline",
                         "description",
                         "priority",
                         "status",
                         "is_pinned",
                         "due_date",
                         "remind_at",
                         "completed_at",
                         "created_at",
                         "updated_at")
  SELECT "task_uuid",
         "owner_uuid",
         "list_uuid",
         "position_in_list",
         "title",
         "headline",
         "description",
         "priority",
         "status",
         "is_pinned",
         "due_date",
         "remind_at",
         "completed_at",
         "created_at",
         "updated_at"
    FROM "moved_task";
  SELECT count(1)
    INTO n_inserted_rows
    FROM "tasks"."task" t
   WHERE t."owner_uuid" = p_owner_uuid
     AND t."list_uuid" = p_list_uuid
     AND t."task_uuid" = p_task_uuid;
  RETURN n_inserted_rows = 1;
END;
$$;
