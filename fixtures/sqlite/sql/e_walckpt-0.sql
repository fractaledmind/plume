ATTACH 'test.db2' AS aux;
ATTACH 'test.db3' AS aux2;
ATTACH 'test.db4' AS aux3;
CREATE TABLE t1(x);
CREATE TABLE aux.t2(x);
CREATE TABLE aux2.t3(x);
CREATE TABLE aux3.t4(x);
PRAGMA main.journal_mode = WAL;
PRAGMA aux.journal_mode = WAL;
PRAGMA aux2.journal_mode = WAL;
/* Leave aux4 in rollback mode */