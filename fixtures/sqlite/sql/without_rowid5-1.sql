DROP TABLE IF EXISTS t5;
CREATE TABLE t5(
a INT NOT NULL ON CONFLICT ABORT,
b TEXT,
c TEXT,
PRIMARY KEY(a,b)
) WITHOUT ROWID;
BEGIN;
INSERT INTO t5(a,b,c) VALUES(1,2,3);