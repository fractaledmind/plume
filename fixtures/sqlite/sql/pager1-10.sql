BEGIN;
SAVEPOINT abc;
CREATE TABLE t1(a, b);
ROLLBACK TO abc;
COMMIT;