DELETE FROM t1;
INSERT INTO t1 VALUES(hex_to_utf16le('00D8'));
SELECT hex(x) FROM t1;