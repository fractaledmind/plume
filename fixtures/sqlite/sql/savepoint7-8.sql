SAVEPOINT x2;
INSERT INTO t2 VALUES($a,$b,$c);
ROLLBACK TO x2;