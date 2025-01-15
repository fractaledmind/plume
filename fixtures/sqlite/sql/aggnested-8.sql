DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1(id1, value1);
INSERT INTO t1 VALUES(4469,2),(4469,1);
CREATE TABLE t2 (value2);
INSERT INTO t2 VALUES(1);
SELECT (SELECT sum(value2=value1) FROM t2), max(value1)
FROM t1
GROUP BY id1;