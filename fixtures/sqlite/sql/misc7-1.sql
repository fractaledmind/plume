DELETE FROM abc WHERE rowid > 12;
INSERT INTO abc SELECT
randstr(100,100), randstr(100,100), randstr(100,100) FROM abc;