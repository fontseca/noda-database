CREATE OR REPLACE FUNCTION "lists"."convert_to_scattered_list"
(
  IN p_owner_uuid "lists"."list"."owner_uuid"%TYPE,
  IN p_list_uuid  "lists"."list"."list_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  current_group_uuid "lists"."list"."group_uuid"%TYPE;
  n_affected_rows    INT;
BEGIN
  CALL "users"."assert_exists"(p_owner_uuid);
  CALL "lists"."assert_is_not_special_list"(p_owner_uuid, p_list_uuid);
  CALL "lists"."assert_exists_somewhere"(p_owner_uuid, p_list_uuid);
  SELECT l."group_uuid"
    INTO current_group_uuid
    FROM "lists"."list" l
   WHERE l."owner_uuid" = p_owner_uuid
     AND l."list_uuid" = p_list_uuid;
  IF current_group_uuid IS NULL
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "lists"."list"
     SET "group_uuid" = NULL,
         "updated_at" = current_timestamp
   WHERE "owner_uuid" = p_owner_uuid
     AND "list_uuid" = p_list_uuid;
  GET DIAGNOSTICS n_affected_rows := ROW_COUNT;
  RETURN n_affected_rows;
END ;
$$;
