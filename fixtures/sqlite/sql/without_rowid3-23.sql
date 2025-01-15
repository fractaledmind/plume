ATTACH ':memory:' AS aux;
CREATE TABLE aux.t1(a PRIMARY KEY) WITHOUT rowid;
CREATE TABLE aux.t2(a, b);
INSERT INTO aux.t2(a,b) VALUES(1,2);