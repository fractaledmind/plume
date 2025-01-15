CREATE TABLE t51(x, y);
CREATE TABLE t52(x, y);
CREATE VIEW v5 as
SELECT x, y FROM t51
UNION ALL
SELECT x, y FROM t52;
CREATE INDEX t51x ON t51(x);
CREATE INDEX t52x ON t52(x);
EXPLAIN QUERY PLAN
SELECT * FROM v5 WHERE x='12345' ORDER BY y;