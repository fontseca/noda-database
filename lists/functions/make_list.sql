CREATE OR REPLACE FUNCTION "lists"."make"(
  IN "p_owner_id" "lists"."list"."list_uuid"%TYPE,
  IN "p_group_id" "lists"."list"."group_uuid"%TYPE,
  IN "p_l_name" "list"."name"%TYPE,
  IN "p_l_desc" "list"."description"%TYPE
)
  RETURNS "lists"."list"."list_uuid"%TYPE
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "is_scattered_list"   BOOLEAN := "p_group_id" IS NULL;
  "inserted_list_id"    "lists"."list"."list_uuid"%TYPE;
  "similar_names_count" INT;
BEGIN
  CALL "users"."assert_exists"("p_owner_id");
  IF "is_scattered_list" IS FALSE THEN
    CALL "groups"."assert_exists"("p_owner_id", "p_group_id");
  END IF;
  "p_l_name" := nullif(trim(BOTH ' ' FROM "p_l_name"), '');
  "p_l_desc" := nullif(trim(BOTH ' ' FROM "p_l_desc"), '');
  SELECT count(*)
  INTO "similar_names_count"
  FROM "lists"."list" "l"
  WHERE CASE WHEN "is_scattered_list" THEN TRUE ELSE "l"."group_uuid" = "p_group_id" END
    AND regexp_count("l"."name", '^' || "common"."quote_meta"("p_l_name") || '(?: \(\d+\))?$') = 1;
  IF "similar_names_count" > 0 THEN
    "p_l_name" := concat("p_l_name", ' (', "similar_names_count", ')');
  END IF;
  INSERT INTO "lists"."list" ("owner_uuid", "group_uuid", "name", "description")
  VALUES ("p_owner_id",
          CASE WHEN "is_scattered_list" THEN NULL ELSE "p_group_id" END,
          "p_l_name",
          "p_l_desc")
  RETURNING "list_uuid"
    INTO "inserted_list_id";
  RETURN "inserted_list_id";
END ;
$$;
