CREATE TABLE IF NOT EXISTS "lists"."user_special_list"
(
  "user_special_list_uuid" uuid PRIMARY KEY              NOT NULL DEFAULT "addons"."uuid_generate_v4"(),
  "user_uuid"              uuid REFERENCES "users"."user" ("user_uuid") ON DELETE CASCADE,
  "list_uuid"              uuid REFERENCES "lists"."list" ("list_uuid") ON DELETE CASCADE,
  "list_type"              "lists"."special_list_type_t" NOT NULL
);
