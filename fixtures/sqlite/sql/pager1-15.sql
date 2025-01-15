PRAGMA locking_mode=EXCLUSIVE;
SELECT count(*) FROM sqlite_master;
PRAGMA lock_status;