CREATE TABLE t2244(a, b);
CREATE VIRTUAL TABLE t2244e USING echo(t2244);
INSERT INTO t2244 VALUES('AA', 'BB');
INSERT INTO t2244 VALUES('CC', 'DD');
SELECT rowid, * FROM t2244e;