CREATE TABLE t3(a INTEGER, b INTEGER, c, UNIQUE(a,b));
INSERT INTO t3 VALUES
(null, null, 1),
(null, null, 2),
(null, 3, 4),
(null, 3, 5),
(6, null, 7),
(6, null, 8);
SELECT DISTINCT a, b FROM t3 ORDER BY +a, +b;