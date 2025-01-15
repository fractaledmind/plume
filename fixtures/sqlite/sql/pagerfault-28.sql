ATTACH 'test.db2' AS aux;
CREATE TABLE t1(a, b);
CREATE TABLE aux.t2(a, b);