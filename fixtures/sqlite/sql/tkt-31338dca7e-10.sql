SELECT * FROM t3 LEFT JOIN t1 ON d=g LEFT JOIN t4 ON c=h
WHERE (a=1 AND h=4)
OR (b IN (
SELECT x FROM (SELECT e+f+a AS x, e FROM t2 ORDER BY 1 LIMIT 2)
GROUP BY e
));