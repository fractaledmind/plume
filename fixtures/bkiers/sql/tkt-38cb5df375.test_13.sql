-- tkt-38cb5df375.test
-- 
-- execsql {
--       SELECT a FROM (SELECT * FROM t1 ORDER BY a)
--       UNION ALL SELECT a FROM (SELECT a FROM t1 ORDER BY a)
--       ORDER BY 1 DESC
--       LIMIT ii;
-- }
SELECT a FROM (SELECT * FROM t1 ORDER BY a)
UNION ALL SELECT a FROM (SELECT a FROM t1 ORDER BY a)
ORDER BY 1 DESC
LIMIT ii;
