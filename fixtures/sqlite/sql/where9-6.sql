SELECT count(*) FROM t1 UNION ALL
SELECT a FROM t1 WHERE a BETWEEN 85 AND 200;
ROLLBACK;