DROP TABLE IF EXISTS t5;
CREATE TABLE t5(a INTEGER PRIMARY KEY, b);
CREATE UNIQUE INDEX t5i ON t5(b);
INSERT INTO t5 VALUES(1, 'a');
INSERT INTO t5 VALUES(2, 'b');
INSERT INTO t5 VALUES(3, 'c');

CREATE TABLE t5g(a, b, c);
CREATE TRIGGER t5t BEFORE DELETE ON t5 BEGIN
INSERT INTO t5g VALUES(old.a, old.b, (SELECT count(*) FROM t5));
END;