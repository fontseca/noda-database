CREATE OR REPLACE PROCEDURE "users"."assert_predefined_setting_exists"(
  IN "p_setting_key" "users"."setting"."key"%TYPE)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  "n_records"         INT;
  "p_setting_key_txt" TEXT := "p_setting_key"::TEXT;
BEGIN
  IF "p_setting_key" IS NOT NULL THEN
    SELECT count(*)
    INTO "n_records"
    FROM "users"."predefined_setting"
    WHERE "key" = lower("p_setting_key");
    IF "n_records" = 1 THEN
      RETURN;
    END IF;
  ELSE
    "p_setting_key_txt" := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent predefined user setting key: "%"', "p_setting_key_txt"
    USING DETAIL = 'No predefined user setting found with key "' || "p_setting_key_txt" || '".',
    HINT = 'Please check the given predefined user setting key.';
END;
$$;

