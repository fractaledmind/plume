SELECT p, min(q) FROM t1;
SELECT p FROM (SELECT p, min(q) FROM t1);