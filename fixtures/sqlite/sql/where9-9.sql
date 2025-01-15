CREATE TABLE t5(a, b, c, d, e, f, g, x, y);
INSERT INTO t5
SELECT a, b, c, e, d, f, g,
CASE WHEN (a&1)!=0 THEN 'y' ELSE 'n' END,
CASE WHEN (a&2)!=0 THEN 'y' ELSE 'n' END
FROM t1;
CREATE INDEX t5xb ON t5(x, b);
CREATE INDEX t5xc ON t5(x, c);
CREATE INDEX t5xd ON t5(x, d);
CREATE INDEX t5xe ON t5(x, e);
CREATE INDEX t5xf ON t5(x, f);
CREATE INDEX t5xg ON t5(x, g);
CREATE INDEX t5yb ON t5(y, b);
CREATE INDEX t5yc ON t5(y, c);
CREATE INDEX t5yd ON t5(y, d);
CREATE INDEX t5ye ON t5(y, e);
CREATE INDEX t5yf ON t5(y, f);
CREATE INDEX t5yg ON t5(y, g);
CREATE TABLE t6(a, b, c, e, d, f, g, x, y);
INSERT INTO t6 SELECT * FROM t5;
ANALYZE t5;