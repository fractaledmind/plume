SELECT x+y FROM (
SELECT a AS x, b AS y FROM t1
UNION ALL
SELECT a*10 + 0.1, f*10 + 0.1 FROM t1 LEFT JOIN t2 ON (c=d)
UNION ALL
SELECT a*100, b*100 FROM t1
) WHERE y+x NOT NULL ORDER BY 1;