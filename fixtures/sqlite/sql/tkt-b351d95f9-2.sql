DELETE FROM t2;
INSERT INTO t2 SELECT a, coalesce(b,a) FROM t1;
SELECT x, y BETWEEN 'xy' AND 'xz' FROM t2 ORDER BY x;