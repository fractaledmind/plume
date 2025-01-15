BEGIN;
UPDATE t1 SET c=c+1;
PRAGMA lock_status;