CREATE OR REPLACE PROCEDURE "common"."gen_search_pattern"(
  INOUT "p_keyword" TEXT
)
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  "p_keyword" := coalesce(trim(BOTH ' ' FROM "p_keyword"), '');
  IF "p_keyword" IS NOT NULL AND "p_keyword" <> '' THEN
    "p_keyword" := lower("p_keyword");
    "p_keyword" := regexp_replace("p_keyword", '\s+', '.*)(?=.*', 'g');
    "p_keyword" := concat('(?=.*', "p_keyword", '.*).*');
  END IF;
END;
$$;
