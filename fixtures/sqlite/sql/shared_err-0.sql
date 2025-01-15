PRAGMA read_uncommitted = 1;
CREATE TABLE t1(a,b,c);
BEGIN;
SELECT * FROM sqlite_master;