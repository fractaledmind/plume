PRAGMA auto_vacuum = off;
PRAGMA journal_mode = WAL;
CREATE TABLE b(c);
INSERT INTO b VALUES('Tehran');
INSERT INTO b VALUES('Qom');
INSERT INTO b VALUES('Markazi');
PRAGMA wal_checkpoint;