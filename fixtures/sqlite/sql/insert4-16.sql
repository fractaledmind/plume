CREATE TABLE t7a(x INTEGER PRIMARY KEY); INSERT INTO t7a VALUES(123);
CREATE TABLE t7b(y INTEGER REFERENCES t7a);
CREATE TABLE t7c(z INT);  INSERT INTO t7c VALUES(234);
INSERT INTO t7b SELECT * FROM t7c;
SELECT * FROM t7b;