ATTACH 'test.db$i' AS aux;
CREATE TABLE aux.t$i (a INTEGER PRIMARY KEY, b TEXT);
INSERT INTO aux.t$i SELECT * FROM t0 WHERE a BETWEEN $iMin AND $iMax;
DETACH aux;
INSERT INTO dir VALUES('test.db$i', 't$i', $iMin, $iMax);