CREATE TABLE t13(x);
INSERT INTO t13 VALUES(1),(2);
CREATE VIEW v13a AS SELECT x AS y FROM t13;
CREATE VIEW v13b AS SELECT y AS z FROM v13a UNION ALL SELECT y+10 FROM v13a;
CREATE VIEW v13c AS SELECT z FROM v13b UNION ALL SELECT z+20 FROM v13b;