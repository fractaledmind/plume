SELECT EXISTS (
SELECT 1 FROM t2 WHERE x=0
UNION ALL
SELECT 2 FROM t2 WHERE x=-1
UNION ALL
SELECT 3 FROM t2 WHERE x=2
UNION ALL
SELECT 4 FROM t2 WHERE x=-2
UNION ALL
SELECT 5 FROM t2 WHERE x=4
UNION ALL
SELECT 6 FROM t2 WHERE y=0
UNION ALL
SELECT 7 FROM t2 WHERE y=1
UNION ALL
SELECT 8 FROM t2 WHERE y=-3
UNION ALL
SELECT 9 FROM t2 WHERE y=3
UNION ALL
SELECT 10 FROM t2 WHERE y=-4
)