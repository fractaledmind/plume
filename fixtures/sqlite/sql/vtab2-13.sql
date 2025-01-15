UPDATE fkey
SET to_col = (SELECT name FROM v_col WHERE tablename = 't1' AND pk);