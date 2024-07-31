CREATE OR REPLACE FUNCTION "lists"."fetch_by_uuid"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE,
  IN "p_group_uuid" "lists"."list"."group_uuid"%TYPE,
  IN "p_list_uuid" "lists"."list"."list_uuid"%TYPE
)
  RETURNS SETOF "lists"."list"
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "is_scattered_list" CONSTANT BOOLEAN := "p_group_uuid" IS NULL;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  CALL "lists"."assert_is_not_special_list"("p_owner_id", "p_list_uuid");
  CALL "lists"."assert_exists"("p_owner_id", "p_group_uuid", "p_list_uuid");
  RETURN QUERY
    SELECT *
    FROM "lists"."list" "l"
    WHERE "l"."owner_uuid" = "p_owner_id"
      AND CASE
            WHEN "is_scattered_list"
              THEN "l"."group_uuid" IS NULL
            ELSE "l"."group_uuid" = "p_group_uuid"
      END
      AND "l"."list_uuid" = "p_list_uuid";
END;
$$;
