CREATE TABLE tkt3376(a COLLATE nocase PRIMARY KEY);
INSERT INTO tkt3376 VALUES('abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz');
INSERT INTO tkt3376 VALUES('ABXYZ012234567890123456789ABXYZ012234567890123456789ABXYZ012234567890123456789ABXYZ012234567890123456789ABXYZ012234567890123456789ABXYZ012234567890123456789ABXYZ012234567890123456789');
SELECT DISTINCT a FROM tkt3376;