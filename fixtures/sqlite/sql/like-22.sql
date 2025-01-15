PRAGMA case_sensitive_like=on;
CREATE TABLE t3(x TEXT);
CREATE INDEX i3 ON t3(x);
INSERT INTO t3 VALUES('ZZ-upper-upper');
INSERT INTO t3 VALUES('zZ-lower-upper');
INSERT INTO t3 VALUES('Zz-upper-lower');
INSERT INTO t3 VALUES('zz-lower-lower');