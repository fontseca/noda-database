CREATE OR REPLACE FUNCTION compute_next_task_pos
(
  IN p_list_scope "lists"."list"."list_uuid"%TYPE
)
RETURNS pos_t
LANGUAGE 'sql'
AS $$
  SELECT (1 + COALESCE ((SELECT max ("position_in_list")
                           FROM "task"
                          WHERE "list_uuid" = p_list_scope), 0))::pos_t;
$$;

ALTER FUNCTION compute_next_task_pos ("list"."list_uuid"%TYPE)
      OWNER TO "noda";
