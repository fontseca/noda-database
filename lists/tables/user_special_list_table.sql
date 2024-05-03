CREATE TABLE IF NOT EXISTS "lists"."user_special_list"
(
  "user_special_list_uuid" uuid PRIMARY KEY              NOT NULL DEFAULT "addons"."uuid_generate_v4"(),
  "user_uuid"              uuid REFERENCES "users"."user" ("user_uuid"),
  "list_uuid"              uuid REFERENCES "lists"."list" ("list_uuid"),
  "list_type"              "lists"."special_list_type_t" NOT NULL
);
