CREATE OR REPLACE PROCEDURE "tasks"."assert_exists_somewhere"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"     INT;
  "task_uuid_txt" TEXT := "p_task_uuid"::TEXT;
BEGIN
  IF "p_task_uuid" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "tasks"."task"
    WHERE "owner_uuid" = "p_owner_id"
      AND "task_uuid" = "p_task_uuid";
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "task_uuid_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent task with UUID "%"', "task_uuid_txt"
    USING HINT = 'Please check the given task UUID.';
END;
$$;
