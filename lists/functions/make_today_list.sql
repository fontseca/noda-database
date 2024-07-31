CREATE OR REPLACE FUNCTION "lists"."make_today_list"(
  IN "p_owner_id" "lists"."list"."owner_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "today_list_uuid"    "lists"."list"."list_uuid"%TYPE;
  "existent_list_uuid" "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  SELECT "lists"."get_today_list_uuid"("p_owner_id")
  INTO "existent_list_uuid";
  IF "existent_list_uuid" IS NOT NULL THEN
    RAISE EXCEPTION 'today list already exists for user with UUID "%"', "p_owner_id"
      USING HINT = 'Function "make_today_list" should be invoked once per user.';
  END IF;
  INSERT INTO "lists"."list" ("owner_uuid", "group_uuid", "name", "description")
  SELECT "p_owner_id",
         NULL,
         '___today___',
         concat("u"."first_name", ' ', "u"."last_name", '''s today list')
  FROM "users"."user" "u"
  WHERE "u"."user_uuid" = "p_owner_id"
  RETURNING "list_uuid"
    INTO "today_list_uuid";
  INSERT INTO "user_special_list" ("user_uuid", "list_uuid", "list_type")
  VALUES ("p_owner_id", "today_list_uuid", 'today');
  RETURN "today_list_uuid";
END;
$$;
