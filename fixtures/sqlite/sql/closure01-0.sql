CREATE TABLE t2(x INTEGER PRIMARY KEY, y INTEGER);
INSERT INTO t2 SELECT x, y FROM t1 WHERE x<32;
CREATE INDEX t2y ON t2(y);
CREATE VIRTUAL TABLE c2
USING transitive_closure(tablename=t2, idcolumn=x, parentcolumn=y);