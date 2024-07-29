CREATE OR REPLACE FUNCTION "tasks"."update_task"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."list_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE,
  IN "p_update" "tasks"."task_update_t"
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "last_update"   "tasks"."task_update_t";
  "affected_rows" INTEGER := 0;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  SELECT "title",
         "headline",
         "description"
  INTO "last_update"."title",
    "last_update"."headline",
    "last_update"."description"
  FROM "tasks"."task" "t"
  WHERE "t"."owner_uuid" = "p_owner_id"
    AND "t"."list_uuid" = "p_list_id"
    AND "t"."task_id" = "p_task_id";
  "p_update"."title" := trim(BOTH ' ' FROM "p_update"."title");
  "p_update"."headline" := trim(BOTH ' ' FROM "p_update"."headline");
  "p_update"."description" := trim(BOTH ' ' FROM "p_update"."description");
  IF ("p_update"."title" IS NULL OR "p_update"."title" = "last_update"."title") AND
     ("p_update"."headline" IS NULL OR "p_update"."headline" = "last_update"."headline") AND
     ("p_update"."description" IS NULL OR "p_update"."description" = "last_update"."description")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "title"       = coalesce("p_update"."title", "last_update"."title"),
      "headline"    = coalesce("p_update"."headline", "last_update"."headline"),
      "description" = coalesce("p_update"."description", "last_update"."description"),
      "updated_at"  = now()
  WHERE "owner_uuid" = "p_owner_id"
    AND "list_uuid" = "p_list_id"
    AND "task_id" = "p_task_id";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
