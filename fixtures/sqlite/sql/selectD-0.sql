ATTACH ':memory:' AS aux1;
CREATE TABLE t1(a,b); INSERT INTO t1 VALUES(111,'x1');
CREATE TABLE t2(a,b); INSERT INTO t2 VALUES(222,'x2');
CREATE TEMP TABLE t3(a,b); INSERT INTO t3 VALUES(333,'x3');
CREATE TABLE main.t4(a,b); INSERT INTO main.t4 VALUES(444,'x4');
CREATE TABLE aux1.t4(a,b); INSERT INTO aux1.t4 VALUES(555,'x5');