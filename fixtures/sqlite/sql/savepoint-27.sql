BEGIN;
INSERT INTO t1 VALUES(9, 10);
SAVEPOINT s1;
INSERT INTO t1 VALUES(11, 12);
COMMIT;