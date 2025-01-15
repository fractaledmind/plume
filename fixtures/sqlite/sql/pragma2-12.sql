ROLLBACK;
PRAGMA cache_spill=100000;
PRAGMA cache_spill;
BEGIN;
UPDATE t1 SET c=c+1;
PRAGMA lock_status;