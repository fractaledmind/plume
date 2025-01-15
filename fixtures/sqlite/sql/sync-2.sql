PRAGMA main.synchronous=full;
PRAGMA db2.synchronous=full;
BEGIN;
INSERT INTO t1 VALUES(3,4);
INSERT INTO t2 VALUES(5,6);
COMMIT;