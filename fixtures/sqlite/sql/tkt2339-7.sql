SELECT * FROM (SELECT * FROM t1 LIMIT 2)
UNION
SELECT * FROM (SELECT * FROM t2 LIMIT 2)