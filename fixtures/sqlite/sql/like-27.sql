CREATE TABLE t10(
a INTEGER PRIMARY KEY,
b INTEGER COLLATE nocase UNIQUE,
c NUMBER COLLATE nocase UNIQUE,
d BLOB COLLATE nocase UNIQUE,
e COLLATE nocase UNIQUE,
f TEXT COLLATE nocase UNIQUE
);
INSERT INTO t10 VALUES(1,1,1,1,1,1);
INSERT INTO t10 VALUES(12,12,12,12,12,12);
INSERT INTO t10 VALUES(123,123,123,123,123,123);
INSERT INTO t10 VALUES(234,234,234,234,234,234);
INSERT INTO t10 VALUES(345,345,345,345,345,345);
INSERT INTO t10 VALUES(45,45,45,45,45,45);