BEGIN;
CREATE TABLE t1(rowid INTEGER PRIMARY KEY, i INTEGER, t TEXT);
CREATE TABLE t2(rowid INTEGER PRIMARY KEY, i INTEGER, t TEXT);
CREATE TABLE t3(rowid INTEGER PRIMARY KEY, i INTEGER, t TEXT);

CREATE VIEW v1 AS SELECT rowid, i, t FROM t1;
CREATE VIEW v2 AS SELECT rowid, i, t FROM t2;
CREATE VIEW v3 AS SELECT rowid, i, t FROM t3;