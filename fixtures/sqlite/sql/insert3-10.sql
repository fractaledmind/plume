CREATE TABLE t4(a,b,c);
CREATE TRIGGER t4r1 AFTER INSERT on t4 WHEN nosuchcol BEGIN
SELECT 'illegal WHEN clause';
END;