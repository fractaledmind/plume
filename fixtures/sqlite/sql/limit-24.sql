DELETE FROM t5;
INSERT INTO t5 SELECT x-y, x+y FROM t1 WHERE x BETWEEN 10 AND 15
ORDER BY x DESC LIMIT 2;
SELECT * FROM t5 ORDER BY x;