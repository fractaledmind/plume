SELECT EXISTS (
SELECT 1 FROM t2 WHERE x=0
UNION
SELECT 2 FROM t2 WHERE x=-1
UNION
SELECT 3 FROM t2 WHERE x=2
UNION
SELECT 4 FROM t2 WHERE x=-1
UNION
SELECT 5 FROM t2 WHERE x=4
UNION
SELECT 6 FROM t2 WHERE y=0
UNION
SELECT 7 FROM t2 WHERE y=1
UNION
SELECT 8 FROM t2 WHERE y=2
UNION
SELECT 9 FROM t2 WHERE y=3
UNION
SELECT 10 FROM t2 WHERE y=-4
)