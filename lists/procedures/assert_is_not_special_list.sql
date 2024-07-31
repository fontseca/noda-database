CREATE OR REPLACE PROCEDURE "lists"."assert_is_not_special_list"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid"    "lists"."list"."list_uuid"%TYPE := "lists"."get_today_list_uuid"("p_owner_id");
  "tomorrow_list_uuid" "lists"."list"."list_uuid"%TYPE := "lists"."get_tomorrow_list_uuid"("p_owner_id");
BEGIN
  IF "today_list_uuid" = "p_list_uuid" OR "tomorrow_list_uuid" = "p_list_uuid" THEN
    RAISE EXCEPTION 'nonexistent list with UUID "%"', "p_list_uuid"::TEXT
      USING HINT = 'Please check the given list UUID.';
  END IF;
END;
$$;
