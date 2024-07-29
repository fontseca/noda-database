CREATE OR REPLACE PROCEDURE "tasks"."assert_task_exists_somewhere"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"   INT;
  "task_id_txt" TEXT := "p_task_id"::TEXT;
BEGIN
  IF "p_task_id" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "tasks"."task"
    WHERE "owner_uuid" = "p_owner_id"
      AND "task_id" = "p_task_id";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "task_id_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent task with ID "%"', "task_id_txt"
    USING HINT = 'Please check the given task ID.';
END;
$$;
