SELECT log AS x FROM t1
GROUP BY x
HAVING count(*)>=4
ORDER BY max(n)+0