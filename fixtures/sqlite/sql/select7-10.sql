CREATE TABLE t5(a TEXT, b INT);
INSERT INTO t5 VALUES(123, 456);
SELECT typeof(a), a FROM t5 GROUP BY a HAVING a<b;