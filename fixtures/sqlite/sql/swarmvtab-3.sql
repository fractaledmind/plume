CREATE TABLE t0(a INTEGER PRIMARY KEY, b TEXT);
WITH s(i) AS ( SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<400)
INSERT INTO t0 SELECT i, hex(randomblob(50)) FROM s;
CREATE TABLE dir(f, t, imin, imax);