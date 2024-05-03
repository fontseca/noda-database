CREATE OR REPLACE PROCEDURE "lists"."assert_is_not_special_list"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_list_id" "lists"."list"."list_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_id"    "lists"."list"."list_uuid"%TYPE := "lists"."get_today_list_id"("p_owner_id");
  "tomorrow_list_id" "lists"."list"."list_uuid"%TYPE := "lists"."get_tomorrow_list_id"("p_owner_id");
BEGIN
  IF "today_list_id" = "p_list_id" OR "tomorrow_list_id" = "p_list_id" THEN
    RAISE EXCEPTION 'nonexistent list with ID "%"', "p_list_id"::TEXT
      USING HINT = 'Please check the given list ID.';
  END IF;
END;
$$;

