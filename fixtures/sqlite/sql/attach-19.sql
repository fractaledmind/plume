CREATE TABLE t1(x);
CREATE TABLE t2(a,b);
CREATE TRIGGER x1 AFTER INSERT ON t1 BEGIN
INSERT INTO t2(a,b) SELECT key, value FROM json_each(NEW.x);
END;
INSERT INTO t1(x) VALUES('{"a":1