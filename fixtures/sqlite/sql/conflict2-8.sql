CREATE TABLE t13(a PRIMARY KEY CHECK(a!=2)) WITHOUT rowid;
BEGIN;
REPLACE INTO t13 VALUES(1);