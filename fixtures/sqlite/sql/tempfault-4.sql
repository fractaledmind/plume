BEGIN;
UPDATE t1 SET a = randomblob(99);
SAVEPOINT abc;
UPDATE t1 SET a = randomblob(98) WHERE (rowid%10)==0;
ROLLBACK TO abc;
UPDATE t1 SET a = randomblob(97) WHERE (rowid%5)==0;
ROLLBACK TO abc;
COMMIT;