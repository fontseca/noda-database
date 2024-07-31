CREATE OR REPLACE FUNCTION "tasks"."set_as_completed"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_uuid" "tasks"."task"."task_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE
)
  RETURNS BOOLEAN
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INT;
BEGIN
  IF (SELECT "t"."status"
      FROM "tasks"."task" "t"
      WHERE "t"."owner_uuid" = "p_owner_id"
        AND "t"."list_uuid" = "p_list_uuid"
        AND "t"."task_uuid" = "p_task_uuid") = 'finished'::"tasks"."task_status_t"
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "status"     = 'finished',
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_uuid"
    AND "tasks"."task"."task_uuid" = "p_task_uuid";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
