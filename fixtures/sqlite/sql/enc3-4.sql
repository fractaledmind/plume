CREATE TABLE t2(a);
INSERT INTO t2 VALUES(x'61006200630064006500');
SELECT CAST(a AS text) FROM t2 WHERE CAST(a AS text) LIKE 'abc%';