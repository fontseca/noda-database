CREATE OR REPLACE PROCEDURE "groups"."assert_exists"
(
  IN p_owner_uuid "groups"."group"."owner_uuid"%TYPE,
  IN p_group_uuid "groups"."group"."group_uuid"%TYPE
)
  LANGUAGE 'plpgsql'
AS
$$
DECLARE
  n_records      INT;
  group_uuid_txt TEXT := p_group_uuid::TEXT;
BEGIN
  IF p_group_uuid IS NOT NULL
  THEN
    SELECT count(*)
      INTO n_records
      FROM "groups"."group"
     WHERE "owner_uuid" = p_owner_uuid
       AND "group_uuid" = p_group_uuid;
    IF n_records = 1
    THEN
      RETURN;
    END IF;
  ELSE
    group_uuid_txt := '(NULL)';
  END IF;
  RAISE EXCEPTION 'nonexistent group with UUID "%"', group_uuid_txt
    USING HINT = 'Please check the given group UUID.';
END;
$$;
