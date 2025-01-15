CREATE TABLE t1(a INTEGER PRIMARY KEY, b);
INSERT INTO t1 VALUES(1,11), (2,22);
CREATE TABLE t2(d, e, UNIQUE(d,e));
INSERT INTO t2 VALUES(10, 'ten'), (11,'eleven'), (12,'twelve'),
(11, 'oneteen');