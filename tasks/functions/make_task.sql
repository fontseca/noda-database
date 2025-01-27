CREATE OR REPLACE FUNCTION "tasks"."make"
(
  IN p_owner_uuid    "users"."user"."user_uuid"%TYPE,
  IN p_list_uuid     "tasks"."task"."list_uuid"%TYPE,
  IN p_task_creation "tasks"."task_creation_t"
)
  RETURNS "tasks"."task"."task_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  inserted_uuid     "tasks"."task"."task_uuid"%TYPE;
  actual_list_uuid  "tasks"."task"."task_uuid"%TYPE := p_list_uuid;
  n_similar_titles  INT                             := 0;
  actual_list_title "tasks"."task"."title"%TYPE     := p_task_creation."title";
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  IF actual_list_uuid IS NOT NULL
  THEN
    CALL "lists"."assert_exists_somewhere"(p_owner_uuid, actual_list_uuid);
  ELSE
    actual_list_uuid := "lists"."get_today_list_uuid"(p_owner_uuid);
    IF actual_list_uuid IS NULL
    THEN
      actual_list_uuid := "lists"."make_today_list"(p_owner_uuid);
    END IF;
  END IF;
  SELECT count(*)
    INTO n_similar_titles
    FROM "tasks"."task" t
   WHERE "list_uuid" = p_list_uuid
     AND regexp_count(t."title", '^' || "common"."quote_meta"(actual_list_title) || '(?: \(\d+\))?$') = 1;
  IF n_similar_titles > 0
  THEN
    actual_list_title := concat(actual_list_title, ' ', '(', n_similar_titles, ')');
  END IF;
     INSERT INTO "tasks"."task" ("owner_uuid",
                                 "list_uuid",
                                 "position_in_list",
                                 "title",
                                 "headline",
                                 "description",
                                 "priority",
                                 "status",
                                 "due_date",
                                 "remind_at")
     VALUES (p_owner_uuid,
             actual_list_uuid,
             "tasks"."compute_next_position"(actual_list_uuid),
             actual_list_title,
             nullif(p_task_creation."headline", ''),
             nullif(p_task_creation."description", ''),
             coalesce(p_task_creation."priority", 'normal'::"tasks"."task_priority_t"),
             coalesce(p_task_creation."status", 'in progress'::"tasks"."task_status_t"),
             p_task_creation."due_date",
             p_task_creation."remind_at")
  RETURNING "task_uuid"
    INTO inserted_uuid;
  RETURN inserted_uuid;
END;
$$;
