CREATE TABLE tbl(a, b, c, PRIMARY KEY(c,a,b)) WITHOUT rowid;
CREATE TRIGGER tbl_trig BEFORE INSERT ON tbl
BEGIN
INSERT INTO tbl VALUES (new.a, new.b, new.c+1);
END;