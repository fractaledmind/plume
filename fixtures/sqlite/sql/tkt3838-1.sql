CREATE TABLE log(y);
CREATE TRIGGER r1 AFTER INSERT ON T1 BEGIN
INSERT INTO log VALUES(new.x);
END;
INSERT INTO t1(x) VALUES(123);
ALTER TABLE T1 RENAME TO XYZ2;
INSERT INTO xyz2(x) VALUES(456);
ALTER TABLE xyz2 RENAME TO pqr3;
INSERT INTO pqr3(x) VALUES(789);
SELECT * FROM log;