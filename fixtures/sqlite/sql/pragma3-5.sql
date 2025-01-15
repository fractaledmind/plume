PRAGMA data_version;
BEGIN;
CREATE TABLE t3(a,b,c);
CREATE TABLE t4(x,y,z);
INSERT INTO t4 VALUES(123,456,789);
PRAGMA data_version;
COMMIT;
PRAGMA data_version;