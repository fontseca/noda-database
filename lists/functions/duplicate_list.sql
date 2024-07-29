CREATE OR REPLACE FUNCTION "lists"."duplicate"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "current_list" "lists"."list"%ROWTYPE;
  "new_list_uuid"  "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_is_not_special_list"("p_owner_id", "p_list_uuid");
  CALL "lists"."assert_list_exists_somewhere"("p_owner_id", "p_list_uuid");
  SELECT *
  INTO "current_list"
  FROM "lists"."list"
  WHERE "owner_uuid" = "p_owner_id"
    AND "list_uuid" = "p_list_uuid";
  "new_list_uuid" := "tasks"."make_list"("p_owner_id",
                                       "current_list"."group_uuid",
                                       "current_list"."name",
                                       "current_list"."description");
  PERFORM *
  FROM "tasks"."task" "t", LATERAL "tasks"."make_task"("p_owner_id",
                                                       "new_list_uuid",
                                                       ROW ("t"."title",
                                                         "t"."headline",
                                                         "t"."description",
                                                         "t"."priority",
                                                         "t"."status",
                                                         "t"."due_date",
                                                         "t"."remind_at"))
  WHERE "owner_uuid" = "p_owner_id"
    AND "list_uuid" = "p_list_uuid";
  RETURN "new_list_uuid";
END;
$$;
