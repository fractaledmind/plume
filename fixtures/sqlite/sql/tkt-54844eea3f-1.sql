SELECT 'test-2', t3.c, (
SELECT count(*)
FROM t1 JOIN (SELECT DISTINCT t3.c AS p FROM t2) AS x ON t1.a=x.p
)
FROM t3;