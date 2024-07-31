CREATE OR REPLACE FUNCTION "tasks"."fetch_by_uuid"(
  IN "p_owner_id" "tasks"."task"."owner_uuid"%TYPE,
  IN "p_list_uuid" "tasks"."task"."list_uuid"%TYPE,
  IN "p_task_uuid" "tasks"."task"."task_uuid"%TYPE
)
  RETURNS SETOF "tasks"."task"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_exists_somewhere"("p_owner_id", "p_list_uuid");
  CALL "tasks"."assert_exists"("p_owner_id", "p_list_uuid", "p_task_uuid");
  RETURN QUERY
    SELECT *
    FROM "tasks"."task" "t"
    WHERE "t"."owner_uuid" = "p_owner_id"
      AND "t"."list_uuid" = "p_list_uuid"
      AND "t"."task_uuid" = "p_task_uuid";
END;
$$;
