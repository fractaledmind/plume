BEGIN;
UPDATE t2 SET a = a||'x' WHERE rowid%2==0;