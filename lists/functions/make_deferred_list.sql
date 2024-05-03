CREATE OR REPLACE FUNCTION "lists"."make_deferred_list"(
  IN "p_owner_id" "lists"."list"."list_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  RETURNS NULL ON NULL INPUT
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "deferred_list_id" "lists"."list"."list_uuid"%TYPE;
  "existent_list_id" "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  "existent_list_id" := lists."get_deferred_list_id"("p_owner_id");
  IF "existent_list_id" IS NOT NULL THEN
    RAISE EXCEPTION 'deferred list already exists for user with ID "%"', "p_owner_id"
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
    INTO "deferred_list_id";
  INSERT INTO "user_special_list" ("user_uuid", "list_uuid", "list_type")
  VALUES ("p_owner_id", "deferred_list_id", 'deferred');
  RETURN "deferred_list_id";
END;
$$;
