CREATE OR REPLACE FUNCTION "users"."block"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE,
  IN "p_blocked_by" "users"."user"."user_uuid"%TYPE,
  IN "p_reason" VARCHAR(512)
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "affected_rows" INTEGER;
BEGIN
  CALL "users"."assert_exists"("p_user_uuid");
  WITH "user_to_block" AS
         (DELETE FROM "users"."user"
           WHERE "user_uuid" = "p_user_uuid"
           RETURNING *)
  INSERT
  INTO "blocked_user" ("user_uuid",
                       "role_uuid",
                       "first_name",
                       "middle_name",
                       "last_name",
                       "surname",
                       "picture_url",
                       "email",
                       "password",
                       "created_at",
                       "updated_at",
                       "reason",
                       "blocked_by")
  SELECT "b"."user_uuid",
         "b"."role_uuid",
         "b"."first_name",
         "b"."middle_name",
         "b"."last_name",
         "b"."surname",
         "b"."picture_url",
         "b"."email",
         "b"."password",
         "b"."created_at",
         "b"."updated_at",
         coalesce("p_reason", 'unknown'),
         "p_blocked_by"
  FROM "user_to_block" "b";
  GET DIAGNOSTICS "affected_rows" = ROW_COUNT;
  RETURN "affected_rows";
END;
$$;

CREATE OR REPLACE FUNCTION "users"."block"(
  IN "p_user_uuid" "users"."user"."user_uuid"%TYPE
)
  RETURNS BOOLEAN
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  RETURN "users"."block"("p_user_uuid", NULL, NULL);
END;
$$;
