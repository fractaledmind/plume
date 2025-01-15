CREATE TABLE t4(a, b, c);
INSERT INTO t4 VALUES('a', 1, 'one');
INSERT INTO t4 VALUES('a', 2, 'two');
INSERT INTO t4 VALUES('b', 1, 'three');
INSERT INTO t4 VALUES('b', 2, 'four');
SELECT (
SELECT c FROM (
SELECT * FROM t4 WHERE a=out.a ORDER BY b LIMIT 10 OFFSET 1
) WHERE b=out.b
) FROM t4 AS out;