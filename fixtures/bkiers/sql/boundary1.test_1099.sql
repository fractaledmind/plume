-- boundary1.test
-- 
-- db eval {
--     SELECT a FROM t1 WHERE rowid <= -8388609 ORDER BY a
-- }
SELECT a FROM t1 WHERE rowid <= -8388609 ORDER BY a