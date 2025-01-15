PRAGMA automatic_index=OFF;
SELECT b, (SELECT d FROM t2 WHERE c=a) FROM t1;