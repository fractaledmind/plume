CREATE TABLE t1(x, y REAL);
INSERT INTO t1 VALUES(1, '1.0');
INSERT INTO t1 VALUES(2, '.125');
INSERT INTO t1 VALUES(3, '123.');
INSERT INTO t1 VALUES(4, '123.e+2');
INSERT INTO t1 VALUES(5, '.125e+3');
INSERT INTO t1 VALUES(6, '123e4');
INSERT INTO t1 VALUES(11, '  1.0');
INSERT INTO t1 VALUES(12, '  .125');
INSERT INTO t1 VALUES(13, '  123.');
INSERT INTO t1 VALUES(14, '  123.e+2');
INSERT INTO t1 VALUES(15, '  .125e+3');
INSERT INTO t1 VALUES(16, '  123e4');
INSERT INTO t1 VALUES(21, '1.0  ');
INSERT INTO t1 VALUES(22, '.125  ');
INSERT INTO t1 VALUES(23, '123.  ');
INSERT INTO t1 VALUES(24, '123.e+2  ');
INSERT INTO t1 VALUES(25, '.125e+3  ');
INSERT INTO t1 VALUES(26, '123e4  ');
SELECT x FROM t1 WHERE typeof(y)=='real' ORDER BY x;