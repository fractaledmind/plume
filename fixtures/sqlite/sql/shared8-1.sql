PRAGMA writable_schema = 1;
DELETE FROM sqlite_master WHERE 1;
PRAGMA writable_schema = 0;
SELECT * FROM sqlite_master;