PRAGMA case_sensitive_like=off;
BEGIN;
CREATE TABLE t1(a, b TEXT COLLATE nocase);
CREATE INDEX i1 ON t1(b);