ROLLBACK;
PRAGMA cache_spill=25;
PRAGMA main.cache_spill;
BEGIN;
UPDATE t1 SET c=c+1;
PRAGMA lock_status;