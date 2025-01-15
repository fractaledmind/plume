SELECT count(*) FROM abc;
PRAGMA locking_mode = exclusive;
BEGIN;
INSERT INTO abc VALUES(randomblob(1500));
COMMIT;