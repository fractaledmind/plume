SELECT z.x FROM (
SELECT a AS x,b AS y FROM t3 UNION SELECT a, b FROM t4 ORDER BY a,b
) AS 'z' ORDER BY x;