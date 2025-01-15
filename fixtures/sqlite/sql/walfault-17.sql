PRAGMA locking_mode = normal;
BEGIN;
INSERT INTO abc VALUES(randomblob(1500));
COMMIT;