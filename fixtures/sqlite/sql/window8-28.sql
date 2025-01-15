SELECT (
SELECT max(a) OVER ( ORDER BY (SELECT sum(a) FROM t1) )
+ min(a) OVER()
)
FROM t1