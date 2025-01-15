CREATE TABLE t2(a,b,c);
INSERT INTO t2 VALUES
(1,null,2),
(1,2,3),
(1,1,4),
(2,3,5);
SELECT a, max(b), c FROM t2 GROUP BY a ORDER BY a;