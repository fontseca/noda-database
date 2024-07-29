CREATE OR REPLACE FUNCTION "users"."unblock"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
BEGIN
  WITH "user_to_unblock" AS
         (DELETE FROM "users"."blocked_user"
           WHERE "user_uuid" = "p_user_uuid"
           RETURNING *)
  INSERT
  INTO "users"."user" ("user_uuid",
                       "role_uuid",
                       "first_name",
                       "middle_name",
                       "last_name",
                       "surname",
                       "picture_url",
                       "email",
                       "password",
                       "created_at",
                       "updated_at")
  SELECT "user_uuid",
         "role_uuid",
         "first_name",
         "middle_name",
         "last_name",
         "surname",
         "picture_url",
         "email",
         "password",
         "created_at",
         "updated_at"
  FROM "user_to_unblock";
  GET DIAGNOSTICS "affected_rows" = ROW_COUNT;
  RETURN "affected_rows";
END;
$$;
