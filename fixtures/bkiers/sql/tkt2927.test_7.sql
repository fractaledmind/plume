-- tkt2927.test
-- 
-- db eval {
--     SELECT a, abs(b) FROM t1
--     UNION ALL
--     SELECT a, abs(b) FROM t1
-- }
SELECT a, abs(b) FROM t1
UNION ALL
SELECT a, abs(b) FROM t1