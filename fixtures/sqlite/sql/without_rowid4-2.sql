CREATE TABLE tblA(a, b, PRIMARY KEY(a,b)) WITHOUT rowid;
CREATE TABLE tblB(a, b, PRIMARY KEY(a,b)) WITHOUT rowid;
CREATE TABLE tblC(a, b, PRIMARY KEY(a,b)) WITHOUT rowid;

CREATE TRIGGER tr1 BEFORE INSERT ON tblA BEGIN
INSERT INTO tblB values(new.a, new.b);
END;

CREATE TRIGGER tr2 BEFORE INSERT ON tblB BEGIN
INSERT INTO tblC values(new.a, new.b);
END;