CREATE TABLE t102 (id TEXT UNIQUE NOT NULL);
INSERT INTO t102 VALUES ('1');
SELECT * FROM t102 AS t0
LEFT JOIN t102 AS t1 ON t1.id GLOB 'abc%'
JOIN t102 AS t2 ON (t2.id = t0.id OR (t2.id<>555 AND t2.id=t1.id));