ALTER TABLE t1 ADD COLUMN g DEFAULT -9223372036854775808;
SELECT g, typeof(g) FROM t1;