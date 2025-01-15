DROP TABLE IF EXISTS t5;
DROP TABLE IF EXISTS m1;
DROP TABLE IF EXISTS m2;
CREATE TABLE t5(a INTEGER PRIMARY KEY, b TEXT, c TEXT);
CREATE TABLE m1(x INTEGER PRIMARY KEY, y TEXT);
CREATE TABLE m2(u INTEGER PRIMARY KEY, v TEXT);

INSERT INTO t5 VALUES(1, 'one', 'ONE');
INSERT INTO t5 VALUES(2, 'two', 'TWO');
INSERT INTO t5 VALUES(3, 'three', 'THREE');
INSERT INTO t5 VALUES(4, 'four', 'FOUR');

INSERT INTO m1 VALUES(1, 'i');
INSERT INTO m1 VALUES(2, 'ii');
INSERT INTO m1 VALUES(3, 'iii');

INSERT INTO m2 VALUES(1, 'I');
INSERT INTO m2 VALUES(3, 'II');
INSERT INTO m2 VALUES(4, 'III');