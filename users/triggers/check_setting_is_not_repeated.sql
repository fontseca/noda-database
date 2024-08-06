CREATE OR REPLACE FUNCTION "users"."check_setting_is_not_repeated"()
  RETURNS TRIGGER
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  n_settings INT;
BEGIN
  SELECT count(*)
    INTO n_settings
    FROM "users"."setting"
   WHERE "key" = new."key"
     AND "user_uuid" = new."user_uuid";
  IF n_settings >= 1
  THEN
    RAISE EXCEPTION 'Key (key)=(%) is already set for user with UUID ''%s''', new."key", new."user_uuid";
  END IF;
  RETURN new;
END;
$$;

CREATE OR REPLACE TRIGGER "check_setting_is_not_repeated"
  BEFORE INSERT
  ON "users"."setting"
  FOR EACH ROW
EXECUTE FUNCTION "users"."check_setting_is_not_repeated"();
