CREATE OR REPLACE FUNCTION "lists"."make_deferred_list"(
  IN "p_owner_id" "lists"."list"."list_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "deferred_list_uuid" "lists"."list"."list_uuid"%TYPE;
  "existent_list_uuid" "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  "existent_list_uuid" := lists."get_deferred_list_uuid"("p_owner_id");
  IF "existent_list_uuid" IS NOT NULL THEN
    RAISE EXCEPTION 'deferred list already exists for user with UUID "%"', "p_owner_id"
      USING HINT = 'Function "make_deferred_list" should be invoked once per user.';
  END IF;
  INSERT INTO "lists"."list" ("owner_uuid", "group_uuid", "name", "description")
  SELECT "p_owner_id",
         NULL,
         '___deferred___',
         concat("u"."first_name", ' ',
                "u"."last_name",
                '''s deferred list')
  FROM "users"."user" "u"
  WHERE "u"."user_uuid" = "p_owner_id"
  RETURNING "list_uuid"
    INTO "deferred_list_uuid";
  INSERT INTO "user_special_list" ("user_uuid", "list_uuid", "list_type")
  VALUES ("p_owner_id", "deferred_list_uuid", 'deferred');
  RETURN "deferred_list_uuid";
END;
$$;
