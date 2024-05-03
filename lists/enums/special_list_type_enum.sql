DROP TYPE IF EXISTS "lists"."special_list_type_t";
CREATE TYPE "lists"."special_list_type_t" AS ENUM ('today', 'tomorrow', 'deferred');
