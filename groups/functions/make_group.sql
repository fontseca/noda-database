CREATE OR REPLACE FUNCTION "groups"."make"(
  IN "p_owner_id" "groups"."group"."owner_uuid"%TYPE,
  IN "p_g_name" "groups"."group"."name"%TYPE,
  IN "p_g_desc" "groups"."group"."description"%TYPE
)
  RETURNS "groups"."group"."group_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "inserted_id" uuid;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  "p_g_name" := nullif(trim(BOTH ' ' FROM "p_g_name"), '');
  "p_g_desc" := nullif(trim(BOTH ' ' FROM "p_g_desc"), '');
  INSERT INTO "groups"."group" ("owner_uuid", "name", "description")
  VALUES ("p_owner_id", "p_g_name", "p_g_desc")
  RETURNING "group_uuid"
    INTO "inserted_id";
  RETURN "inserted_id";
END;
$$;
