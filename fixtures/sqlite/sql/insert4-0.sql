CREATE TABLE t1(a int, b int, check(b>a));
CREATE TABLE t2(x int, y int);
CREATE VIEW v2 AS SELECT y, x FROM t2;
CREATE TABLE t3(a int, b int);