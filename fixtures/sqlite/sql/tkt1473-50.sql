SELECT (
SELECT 1 FROM t2 WHERE x=1 INTERSECT SELECT 2 FROM t2 WHERE y=2
)