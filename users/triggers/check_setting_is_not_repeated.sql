CREATE OR REPLACE FUNCTION "users"."check_setting_is_not_repeated"()
  RETURNS TRIGGER
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_settings" INT;
BEGIN
  SELECT count(*)
  INTO "n_settings"
  FROM "users"."setting"
  WHERE "key" = NEW."key"
    AND "user_uuid" = NEW."user_uuid";
  IF "n_settings" >= 1 THEN
    RAISE EXCEPTION 'Key (key)=(%) is already set for user with ID ''%s''', NEW."key", NEW."user_uuid";
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER "check_setting_is_not_repeated"
  BEFORE INSERT
  ON  users."setting"
  FOR EACH ROW
EXECUTE FUNCTION "users"."check_setting_is_not_repeated"();
