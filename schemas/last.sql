ALTER ROLE "postgres"
  SET "search_path"
  TO "public", "common", "addons", "users", "groups", "lists", "tasks";
