DROP TABLE IF EXISTS t3;
CREATE TABLE t3(a INTEGER PRIMARY KEY, b INTEGER, c TEXT) %WITHOUT_ROWID%;
INSERT INTO t3 VALUES(1, 1, 'one');
INSERT INTO t3 VALUES(2, 2, 'two');
INSERT INTO t3 VALUES(3, 3, 'three');

DROP TABLE IF EXISTS t4;
CREATE TABLE t4(x TEXT);
INSERT INTO t4 VALUES('five');

SELECT * FROM t3 ORDER BY a;