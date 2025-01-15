CREATE TABLE main.t4(a, b, c);
CREATE TABLE aux.t4(a, b, c);
CREATE TEMP TRIGGER tst_trigger BEFORE INSERT ON aux.t4 BEGIN
SELECT 'hello world';
END;
SELECT count(*) FROM temp.sqlite_master;