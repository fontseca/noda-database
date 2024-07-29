CREATE OR REPLACE FUNCTION "tasks"."trash_task"(
  IN "p_owner_id" "tasks"."task"."task_id"%TYPE,
  IN "p_list_id" "tasks"."task"."list_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_inserted_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  WITH "moved_task" AS
         (
           DELETE FROM "tasks"."task"
             WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
               AND "tasks"."task"."list_uuid" = "p_list_id"
               AND "tasks"."task"."task_id" = "p_task_id"
             RETURNING *)
  INSERT
  INTO "tasks"."trashed_task" ("task_id",
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
                               "updated_at",
                               "trashed_at",
                               "destroy_at")
  SELECT "task_id",
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
         "updated_at",
         now(),
         now() + INTERVAL '7d'
  FROM "moved_task";
  SELECT count(1)
  INTO "n_inserted_rows"
  FROM "tasks"."trashed_task" "t"
  WHERE "t"."owner_uuid" = "p_owner_id"
    AND "t"."list_uuid" = "p_list_id"
    AND "t"."task_id" = "p_task_id";
  RETURN "n_inserted_rows" = 1;
END;
$$;
