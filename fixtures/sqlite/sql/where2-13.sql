SELECT w FROM tx
WHERE x IN (SELECT x FROM t1 WHERE w BETWEEN 2 AND 4)
AND y IN (SELECT y FROM t1 WHERE w BETWEEN 10 AND 20)
AND z IN (SELECT z FROM t1 WHERE w BETWEEN 10 AND 20)