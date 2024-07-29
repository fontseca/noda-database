CREATE OR REPLACE FUNCTION "tasks"."set_task_as_uncompleted"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_id" "tasks"."task"."task_id"%TYPE,
  IN "p_task_id" "tasks"."task"."task_id"%TYPE
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
        AND "t"."list_uuid" = "p_list_id"
        AND "t"."task_id" = "p_task_id") = 'unfinished'::"tasks"."task_status_t"
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "tasks"."task"
  SET "status"     = 'unfinished',
      "updated_at" = now()
  WHERE "tasks"."task"."owner_uuid" = "p_owner_id"
    AND "tasks"."task"."list_uuid" = "p_list_id"
    AND "tasks"."task"."task_id" = "p_task_id";
  GET DIAGNOSTICS "affected_rows" := ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
