DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;

CREATE TEMP TABLE t1(x UNIQUE);
INSERT INTO t1 VALUES(1);
CREATE TABLE t2(x, y);
INSERT INTO t2 VALUES(1, 2);