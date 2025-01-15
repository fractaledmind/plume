CREATE TEMP TABLE chnglog(desc TEXT);
CREATE TEMP TRIGGER xt1_del AFTER DELETE ON xt1 BEGIN
INSERT INTO chnglog VALUES(
printf('DELETE t1: rowid=%d, a=%s, b=%s, c=%s, d=%s',
old.rowid, quote(old.a), quote(old.b), quote(old.c),
quote(old.d)));
END;
CREATE TEMP TRIGGER xt1_ins AFTER INSERT ON xt1 BEGIN
INSERT INTO chnglog VALUES(
printf('INSERT t1:  rowid=%d, a=%s, b=%s, c=%s, d=%s',
new.rowid, quote(new.a), quote(new.b), quote(new.c),
quote(new.d)));
END;