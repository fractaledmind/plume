CREATE VIRTUAL TABLE t1 USING fts4(tokenize=unicode61, x);
INSERT INTO t1 VALUES($a);
INSERT INTO t1 VALUES($b);
INSERT INTO t1 VALUES($c);
INSERT INTO t1 VALUES($d);