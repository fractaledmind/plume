SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC LIMIT 2)
UNION
SELECT * FROM (SELECT * FROM t2 LIMIT 2)