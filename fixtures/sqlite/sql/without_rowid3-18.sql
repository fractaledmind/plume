CREATE TEMP TABLE t1(a PRIMARY KEY) WITHOUT rowid;
CREATE TEMP TABLE t2(a, b);
INSERT INTO temp.t2(a,b) VALUES(1,2);