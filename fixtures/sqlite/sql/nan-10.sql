DELETE FROM t1;
INSERT INTO t1 VALUES('2.5e-9999');
SELECT x, typeof(x) FROM t1;