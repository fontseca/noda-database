CREATE OR REPLACE FUNCTION "tasks"."set_task_reminder_date"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."task_id"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE,
  IN "p_remind_at" timestamptz
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
  "task_due_date" timestamptz;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_id");
  CALL "tasks"."assert_task_exists"("p_owner_id", "p_list_id", "p_task_id");
  IF "p_remind_at" <= now() THEN
    RETURN FALSE;
  END IF;
  SELECT "t"."due_date"
  INTO "task_due_date"
  FROM "tasks"."task" "t"
  WHERE "t"."owner_uuid" = "p_owner_id"
    AND "t"."list_uuid" = "p_list_id"
    AND "t"."task_id" = "p_task_id";
  IF "task_due_date" IS NOT NULL AND "p_remind_at" >= "task_due_date" THEN
    RETURN FALSE;
  END IF;
  IF "p_remind_at" =
     (SELECT "t"."remind_at"
      FROM "tasks"."task" "t"
      WHERE "t"."owner_uuid" = "p_owner_id"
        AND "t"."list_uuid" = "p_list_id"
        AND "t"."task_id" = "p_task_id")
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "remind_at"  = "p_remind_at",
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
