CREATE TABLE t1(
node PRIMARY KEY,
parent REFERENCES t1 ON DELETE CASCADE
) WITHOUT rowid;
CREATE TABLE t2(node PRIMARY KEY, parent) WITHOUT rowid;
CREATE TRIGGER t2t AFTER DELETE ON t2 BEGIN
DELETE FROM t2 WHERE parent = old.node;
END;
INSERT INTO t1 VALUES(1, NULL);
INSERT INTO t1 VALUES(2, 1);
INSERT INTO t1 VALUES(3, 1);
INSERT INTO t1 VALUES(4, 2);
INSERT INTO t1 VALUES(5, 2);
INSERT INTO t1 VALUES(6, 3);
INSERT INTO t1 VALUES(7, 3);
INSERT INTO t2 SELECT * FROM t1;