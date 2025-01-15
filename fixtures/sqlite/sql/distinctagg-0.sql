CREATE TABLE t1(a,b,c);
INSERT INTO t1 VALUES(1,2,3);
INSERT INTO t1 VALUES(1,3,4);
INSERT INTO t1 VALUES(1,3,5);
SELECT count(distinct a),
count(distinct b),
count(distinct c),
count(all a) FROM t1;