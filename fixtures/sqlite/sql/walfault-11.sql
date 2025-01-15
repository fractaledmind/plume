PRAGMA journal_mode = WAL;
PRAGMA wal_autocheckpoint = 0;
BEGIN;
CREATE TABLE abc(a PRIMARY KEY);
INSERT INTO abc VALUES(randomblob(1500));
INSERT INTO abc VALUES(randomblob(1500));
COMMIT;