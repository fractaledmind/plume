CREATE TABLE r(a, b, c);
CREATE VIRTUAL TABLE e USING echo(r, e_log);
SELECT name FROM sqlite_master;