-- rowid.test
-- 
-- execsql {SELECT t2.y FROM t2, t1 WHERE t1.x==4 AND t1.oid==t2.rowid}
SELECT t2.y FROM t2, t1 WHERE t1.x==4 AND t1.oid==t2.rowid