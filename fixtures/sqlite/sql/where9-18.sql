CREATE TABLE t101 (id INTEGER PRIMARY KEY);
INSERT INTO t101 VALUES (1);
SELECT * FROM t101 AS t0
LEFT JOIN t101 AS t1 ON t1.id BETWEEN 10 AND 20
JOIN t101 AS t2 ON (t2.id = t0.id OR (t2.id<>555 AND t2.id=t1.id));