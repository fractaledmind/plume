DROP TABLE IF EXISTS t5;
CREATE TABLE t5(
a INT NOT NULL ON CONFLICT REPLACE DEFAULT 3,
b TEXT,
c TEXT,
PRIMARY KEY(a,b)
) WITHOUT ROWID;
INSERT INTO t5(a,b,c) VALUES(1,2,3),(NULL,4,5),(6,7,8);
SELECT * FROM t5;