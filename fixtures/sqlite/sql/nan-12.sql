DELETE FROM t1;
INSERT INTO t1 VALUES('2.5e2147483650');
SELECT x, typeof(x) FROM t1;