CREATE TABLE t41(a INT UNIQUE NOT NULL, b INT NOT NULL);
CREATE INDEX t41ba ON t41(b,a);
CREATE TABLE t42(x INT NOT NULL REFERENCES t41(a), y INT NOT NULL);
CREATE UNIQUE INDEX t42xy ON t42(x,y);
INSERT INTO t41 VALUES(1,1),(3,1);
INSERT INTO t42 VALUES(1,13),(1,15),(3,14),(3,16);

SELECT b, y FROM t41 CROSS JOIN t42 ON x=a ORDER BY b, y;