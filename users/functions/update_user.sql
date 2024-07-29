CREATE OR REPLACE FUNCTION "users"."update"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE,
  IN "p_first_name" "users"."user"."first_name"%TYPE,
  IN "p_middle_name" "users"."user"."middle_name"%TYPE,
  IN "p_last_name" "users"."user"."last_name"%TYPE,
  IN "p_surname" "users"."user"."surname"%TYPE,
  IN "p_email" "users"."user"."email"%TYPE,
  IN "p_picture_url" "users"."user"."picture_url"%TYPE,
  IN "p_password" "users"."user"."password"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "rows_affected"   INT;
  /* TODO: Use a ROWTYPE instead.   */
  "old_first_name"  "users"."user"."first_name"%TYPE;
  "old_middle_name" "users"."user"."middle_name"%TYPE;
  "old_last_name"   "users"."user"."last_name"%TYPE;
  "old_surname"     "users"."user"."surname"%TYPE;
  "old_email"       TEXT;
  "old_picture_url" "users"."user"."picture_url"%TYPE;
  "old_password"    "users"."user"."password"%TYPE;
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  SELECT "u"."first_name",
         "u"."middle_name",
         "u"."last_name",
         "u"."surname",
         "u"."email",
         "u"."picture_url",
         "u"."password"
  INTO "old_first_name",
    "old_middle_name",
    "old_last_name",
    "old_surname",
    "old_email",
    "old_picture_url",
    "old_password"
  FROM "users"."user" "u"
  WHERE "u"."user_uuid" = "p_user_uuid";
  IF ("old_first_name" = "p_first_name" OR "p_first_name" = '' OR "p_first_name" IS NULL) AND
     ("old_middle_name" = "p_middle_name" OR "p_middle_name" = '' OR "p_middle_name" IS NULL) AND
     ("old_last_name" = "p_last_name" OR "p_last_name" = '' OR "p_last_name" IS NULL) AND
     ("old_surname" = "p_surname" OR "p_surname" = '' OR "p_surname" IS NULL) AND
     ("old_email" = "p_email" OR "p_email" = '' OR "p_email" IS NULL) AND
     ("old_picture_url" = "p_picture_url" OR "p_picture_url" = '' OR "p_picture_url" IS NULL) AND
     ("old_password" = "p_password" OR "p_password" = '' OR "p_password" IS NULL)
  THEN
    RETURN FALSE;
  END IF;
  UPDATE "users"."user"
  SET "first_name"  = coalesce(nullif(trim("p_first_name"), ''), "old_first_name"),
      "middle_name" = coalesce(nullif(trim("p_middle_name"), ''), "old_middle_name"),
      "last_name"   = coalesce(nullif(trim("p_last_name"), ''), "old_last_name"),
      "surname"     = coalesce(nullif(trim("p_surname"), ''), "old_surname"),
      "email"       = coalesce(nullif(trim("p_email"), ''), "old_email"),
      "picture_url" = coalesce(nullif(trim("p_picture_url"), ''), "old_picture_url"),
      "password"    = coalesce(nullif(trim("p_password"), ''), "old_password"),
      "updated_at"  = current_timestamp
  WHERE "users"."user"."user_uuid" = "p_user_uuid";
  GET DIAGNOSTICS "rows_affected" = ROW_COUNT;
  RETURN "rows_affected";
END;
$$;
