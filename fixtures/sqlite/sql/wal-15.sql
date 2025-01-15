ATTACH 'test2.db' AS aux;
PRAGMA main.auto_vacuum = 0;
PRAGMA aux.auto_vacuum = 0;
PRAGMA main.journal_mode = WAL;
PRAGMA aux.journal_mode = WAL;
PRAGMA main.synchronous = NORMAL;
PRAGMA aux.synchronous = NORMAL;