SELECT * FROM (SELECT * FROM t1 ORDER BY num DESC)
UNION ALL
SELECT * FROM (SELECT * FROM t2 ORDER BY num DESC LIMIT 2)