CREATE INDEX i1 ON t1(c);

SELECT * FROM t1 LEFT JOIN t2 ON b=x AND c=1;