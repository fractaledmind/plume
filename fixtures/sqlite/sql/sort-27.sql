INSERT INTO t1 VALUES(9,'x2.7',3,'IX',4.0e5);
INSERT INTO t1 VALUES(10,'x5.0e10',3,'X',-4.0e5);
INSERT INTO t1 VALUES(11,'x-4.0e9',3,'XI',4.1e4);
INSERT INTO t1 VALUES(12,'x01234567890123456789',3,'XII',-4.2e3);
SELECT n FROM t1 ORDER BY n;