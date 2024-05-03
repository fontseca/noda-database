CREATE OR REPLACE FUNCTION "lists"."make_tomorrow_list"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "tomorrow_list_id" "lists"."list"."list_uuid"%TYPE;
  "existent_list_id" "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  SELECT "lists"."get_tomorrow_list_id"("p_owner_id")
  INTO "existent_list_id";
  IF "existent_list_id" IS NOT NULL THEN
    RAISE EXCEPTION 'tomorrow list already exists for user with ID "%"', "p_owner_id"
      USING HINT = 'Function "make_tomorrow_list" should be invoked once per user.';
  END IF;
  INSERT INTO "lists"."list" ("owner_uuid", "group_uuid", "name", "description")
  SELECT "p_owner_id",
         NULL,
         '___tomorrow___',
         concat("u"."first_name", ' ', "u"."last_name", '''s tomorrow list')
  FROM "users"."user" "u"
  WHERE "u"."user_uuid" = "p_owner_id"
  RETURNING "list_uuid"
    INTO "tomorrow_list_id";
  INSERT INTO "user_special_list" ("user_uuid", "list_uuid", "list_type")
  VALUES ("p_owner_id", "tomorrow_list_id", 'tomorrow');
  RETURN "tomorrow_list_id";
END;
$$;
