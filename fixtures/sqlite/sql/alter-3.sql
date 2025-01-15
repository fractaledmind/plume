CREATE TRIGGER trig3 AFTER INSERT ON main.'t8'BEGIN
SELECT trigfunc('trig3', new.a, new.b, new.c);
END;
INSERT INTO t8 VALUES(1, 2, 3);