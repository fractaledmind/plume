CREATE TABLE ""("" UNIQUE, x CHAR(100));
CREATE TABLE t2(x);
INSERT INTO ""("") VALUES(1);
INSERT INTO t2 VALUES(2);
SELECT * FROM "", t2;