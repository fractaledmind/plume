DROP TABLE t1;
CREATE VIRTUAL TABLE t1 USING $create;
INSERT INTO t1 VALUES('one two five four five', '');
INSERT INTO t1 VALUES('', 'one two five four five');
INSERT INTO t1 VALUES('one two', 'five four five');