ALTER TABLE t1 ADD COLUMN c DEFAULT 'c';
INSERT INTO t1(a, b) VALUES(3, 4);
SELECT * FROM log ORDER BY trig, a, b;