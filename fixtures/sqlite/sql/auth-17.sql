CREATE TRIGGER r3 INSTEAD OF DELETE ON v1 BEGIN
INSERT INTO v1chng VALUES(OLD.x,NULL);
END;
SELECT * FROM v1;