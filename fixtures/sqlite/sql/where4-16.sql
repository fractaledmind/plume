CREATE TABLE t5(a,b,c,d,e,f,UNIQUE(a,b,c,d,e,f));
INSERT INTO t5 VALUES(1,1,1,1,1,11111);
INSERT INTO t5 VALUES(2,2,2,2,2,22222);
INSERT INTO t5 VALUES(1,2,3,4,5,12345);
INSERT INTO t5 VALUES(2,3,4,5,6,23456);