ATTACH 'test.db2' AS aux2;
ATTACH 'test.db3' AS aux3;
PRAGMA main.journal_mode = WAL;
PRAGMA aux2.journal_mode = WAL;
PRAGMA aux3.journal_mode = WAL;

CREATE TABLE main.t1(x,y);
CREATE TABLE aux2.t2(x,y);
CREATE TABLE aux3.t3(x,y);

INSERT INTO t1 VALUES('a', 'b');
INSERT INTO t2 VALUES('a', 'b');
INSERT INTO t3 VALUES('a', 'b');