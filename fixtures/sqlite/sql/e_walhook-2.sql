ATTACH 'test.db2' AS aux;
CREATE TABLE aux.t2(x);
PRAGMA aux.journal_mode = wal;