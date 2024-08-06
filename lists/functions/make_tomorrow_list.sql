CREATE OR REPLACE FUNCTION "lists"."make_tomorrow_list"
(
  IN p_owner_uuid "lists"."list"."owner_uuid"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  tomorrow_list_uuid "lists"."list"."list_uuid"%TYPE;
  existent_list_uuid "lists"."list"."list_uuid"%TYPE;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  SELECT "lists"."get_tomorrow_list_uuid"(p_owner_uuid)
    INTO existent_list_uuid;
  IF existent_list_uuid IS NOT NULL
  THEN
    RAISE EXCEPTION 'tomorrow list already exists for user with UUID "%"', p_owner_uuid
      USING HINT = 'Function "make_tomorrow_list" should be invoked once per user.';
  END IF;
     INSERT INTO "lists"."list" ("owner_uuid", "group_uuid", "name", "description")
     SELECT p_owner_uuid,
            NULL,
            '___tomorrow___',
            concat(special_characters."first_name", ' ', special_characters."last_name", '''s tomorrow list')
       FROM "users"."user" special_characters
      WHERE special_characters."user_uuid" = p_owner_uuid
  RETURNING "list_uuid"
    INTO tomorrow_list_uuid;
  INSERT INTO "user_special_list" ("user_uuid", "list_uuid", "list_type")
  VALUES (p_owner_uuid, tomorrow_list_uuid, 'tomorrow');
  RETURN tomorrow_list_uuid;
END;
$$;
