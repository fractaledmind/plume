SELECT sum((
SELECT d FROM t8 WHERE a = i AND b = i AND c < NULL
)) FROM t7;