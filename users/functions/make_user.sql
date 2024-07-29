CREATE OR REPLACE FUNCTION "users"."make"(
  IN "p_first_name" TEXT,
  IN "p_middle_name" TEXT,
  IN "p_last_name" TEXT,
  IN "p_surname" TEXT,
  IN "p_email" "common"."email_t",
  IN "p_password" TEXT
)
  RETURNS uuid
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "new_user_uuid" uuid;
BEGIN
  INSERT INTO "users"."user"
  ("first_name", "middle_name", "last_name", "surname", "email", "password", "role_uuid")
  VALUES ("p_first_name", "p_middle_name", "p_last_name", "p_surname", "p_email", "p_password", '2')
  RETURNING "user_uuid"
    INTO "new_user_uuid";
--   PERFORM "make_today_list"("new_user_uuid"), "make_tomorrow_list"("new_user_uuid");
  RETURN "new_user_uuid";
END;
$$;
