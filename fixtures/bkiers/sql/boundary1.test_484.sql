-- boundary1.test
-- 
-- db eval {
--     SELECT rowid, a FROM t1 WHERE x='ffffffffff800000'
-- }
SELECT rowid, a FROM t1 WHERE x='ffffffffff800000'