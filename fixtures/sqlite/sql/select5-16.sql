CREATE TABLE t3(x,y);
INSERT INTO t3 VALUES(1,NULL);
INSERT INTO t3 VALUES(2,NULL);
INSERT INTO t3 VALUES(3,4);
SELECT count(x), y FROM t3 GROUP BY y ORDER BY 1