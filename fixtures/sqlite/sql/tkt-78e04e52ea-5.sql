CREATE INDEX "" ON t2(x);
EXPLAIN QUERY PLAN SELECT * FROM t2 WHERE x=5;