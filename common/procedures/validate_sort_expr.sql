CREATE OR REPLACE PROCEDURE "common"."validate_sort_expr"
(
  INOUT p_sort_expr TEXT
)
  LANGUAGE 'plpgsql'
AS
$$
BEGIN
  p_sort_expr := coalesce(trim(BOTH ' ' FROM p_sort_expr), '');
  IF p_sort_expr <> '' AND
     p_sort_expr IS NOT NULL AND
     left(p_sort_expr, 1) NOT IN ('+', '-')
  THEN
    p_sort_expr := concat('+', p_sort_expr);
  END IF;
END;
$$;
