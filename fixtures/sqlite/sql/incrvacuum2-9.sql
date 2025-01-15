BEGIN;
DELETE FROM abc;
PRAGMA incremental_vacuum;
COMMIT;