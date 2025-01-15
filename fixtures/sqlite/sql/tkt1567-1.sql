BEGIN;
UPDATE t1 SET a = a||'x' WHERE rowid%2==0;