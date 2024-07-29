INSERT INTO "users"."setting" ("user_uuid", "key", "value")
SELECT "user_uuid",
       "key",
       "default_value"
FROM "users"."user",
     "users"."predefined_setting"
ORDER BY "user_uuid";
