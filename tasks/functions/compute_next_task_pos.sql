CREATE OR REPLACE FUNCTION "tasks"."compute_next_task_pos"(
  IN "p_list_scope" "lists"."list"."list_uuid"%TYPE
)
  RETURNS "common"."pos_t"
  LANGUAGE 'sql'
AS
$$
SELECT (1 + coalesce((SELECT max("position_in_list")
                      FROM "tasks"."task"
                      WHERE "list_uuid" = "p_list_scope"), 0))::"common"."pos_t";
$$;
