DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;

CREATE TEMP TABLE t1(x);
CREATE TABLE t2(x);
CREATE TABLE t3(x);

INSERT INTO t1 VALUES(1);
INSERT INTO t1 VALUES(2);
INSERT INTO t2 VALUES(1);
INSERT INTO t2 VALUES(2);