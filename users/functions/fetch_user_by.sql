CREATE OR REPLACE FUNCTION "users"."fetch_by"(
  IN "p_column" TEXT,
  IN "p_value" TEXT
)
  RETURNS SETOF "users"."user"
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  IF "p_column" IS NULL THEN
    "p_column" = '(NULL)';
  ELSE
    "p_column" := lower(trim(BOTH ' ' FROM "p_column"));
  END IF;
  IF "p_column" = 'user_uuid' THEN
    CALL "users"."assert_exists"("p_value"::uuid);
    RETURN QUERY
      SELECT *
      FROM "users"."user"
      WHERE "user_uuid" = "p_value"::uuid;
  ELSIF "p_column" = 'email' THEN
    RETURN QUERY
      SELECT *
      FROM "users"."user"
      WHERE "email" = "p_value"::"common"."email_t";
    IF NOT FOUND THEN
      IF "p_value" IS NULL THEN
        "p_value" := '(NULL)';
      END IF;
      RAISE EXCEPTION 'nonexistent user email: %', "p_value"
        USING HINT = 'Please check the given user email';
    END IF;
  ELSE
    RAISE EXCEPTION 'unexpected input for "p_column" parameter: "%"', "p_column"
      USING DETAIL = 'The supported values for "p_column" are "email" and "user_uuid"',
        HINT = 'Please check the given user email';
  END IF;
END;
$$;
