CREATE TABLE t6(x,y DEFAULT 4.3, z DEFAULT x'6869');
INSERT INTO t6 DEFAULT VALUES;
SELECT * FROM t6;