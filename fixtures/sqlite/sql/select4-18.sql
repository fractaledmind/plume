SELECT log, count(*) FROM t1 GROUP BY log
UNION
SELECT log, n FROM t1 WHERE n=7
ORDER BY count(*), log;