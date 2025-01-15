SELECT log, count(*) as cnt FROM t1 GROUP BY log
UNION
SELECT log, n FROM t1 WHERE n=7
ORDER BY cnt, log;