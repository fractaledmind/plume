WITH cnt(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM cnt WHERE x<100)
INSERT INTO t1(x, y) SELECT 10000+$i, x FROM cnt;
INSERT INTO t1(x, y) SELECT 10000+$i, 100;