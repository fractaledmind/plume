CREATE TABLE t1(x INTEGER PRIMARY KEY, y TEXT);
INSERT INTO t1 VALUES(1, 'For since by man came death,');
INSERT INTO t1 VALUES(2, 'by man came also the resurrection of the dead.');
INSERT INTO t1 VALUES(3, 'For as in Adam all die,');
INSERT INTO t1 VALUES(4, 'even so in Christ shall all be made alive.');

SELECT x FROM t1 WHERE y REGEXP '^For ' ORDER BY x;