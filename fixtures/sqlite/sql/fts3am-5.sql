DELETE FROM t1 WHERE rowid = 4;
SELECT COUNT(col_a), COUNT(col_b), COUNT(*) FROM t1;