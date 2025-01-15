CREATE TABLE t1(a,b,c,d);
CREATE TABLE t2(e,f);
INSERT INTO t1 VALUES(1,2,3,4);
INSERT INTO t2 VALUES(10,-8);
CREATE INDEX t1a ON t1(a);
CREATE INDEX t1b ON t1(b);
CREATE TABLE t3(g);
INSERT INTO t3 VALUES(4);
CREATE TABLE t4(h);
INSERT INTO t4 VALUES(5);

SELECT * FROM t3 LEFT JOIN t1 ON d=g LEFT JOIN t4 ON c=h
WHERE (a=1 AND h=4)
OR (b IN (
SELECT x FROM (SELECT e+f AS x, e FROM t2 ORDER BY 1 LIMIT 2)
GROUP BY e
));