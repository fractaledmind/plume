BEGIN;
DROP TABLE tbl2;
PRAGMA incremental_vacuum;
COMMIT;