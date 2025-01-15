ROLLBACK;
PRAGMA cache_spill=OFF;
PRAGMA Cache_Spill;
BEGIN;
UPDATE t1 SET c=c+1;
PRAGMA lock_status;