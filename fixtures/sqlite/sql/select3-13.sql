SELECT log, count(*) FROM t1
GROUP BY log
HAVING count(*)>=4
ORDER BY max(n)+0