DELETE FROM t1;
INSERT INTO t1 VALUES(hex_to_utf16be('DFFF'));
SELECT hex(x) FROM t1;