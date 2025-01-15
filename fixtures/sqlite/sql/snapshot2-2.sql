ATTACH 'test.db2' AS aux;
PRAGMA aux.journal_mode = wal;
CREATE TABLE aux.t2(x, y);